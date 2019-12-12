module Main exposing (main, view)

import Bootstrap.CDN as CDN
import Bootstrap.Form as Form
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Browser
import Date exposing (Date)
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (action, class, cols, method, name, placeholder, rows, selected, type_, value)
import Html.Events exposing (..)
import Http
import Json.Decode as Json exposing (Decoder)
import Json.Decode.Pipeline exposing (hardcoded, optional, required)
import Menu



-- TODO:
-- load old data for edit
-- file deletion


type alias Flags =
    { csrf : String
    , id : Int
    }


type alias Area =
    { id : Int
    , name : String
    }


type alias Person =
    { id : Int
    , name : String
    }


type alias ObservationType =
    { id : Int
    , name : String
    }


type alias Unit =
    { id : Int
    , name : String
    }


type alias Equipment =
    { id : Int
    , name : String
    , use_material : Bool
    }


type alias Setup =
    { id : Int
    , equipment : Equipment
    , materials : Dict Int MaterialTransaction
    }


type alias MaterialTransaction =
    { id : Int
    , material : Material
    , amount : Float
    , unit : Unit
    }


type alias Material =
    { id : Int
    , name : String
    }


type alias Activity =
    { person : Person
    , setup : Dict Int Setup
    , id : Int
    }


type alias File =
    { name : String
    }



-- keep all of the list together so that they can be passed around?


type alias Data =
    { observationTypeList : List ObservationType
    , equipmentList : List Equipment
    , unitList : List Unit
    , materialList : List Material
    }


type alias Observation =
    { obs_date : String
    , comment : String
    , areas_as_text : String
    , areas : List Area
    , obsType : List ObservationType
    , activities : Dict Int Activity
    , files : List File
    , id : Int -- Maybe?
    }


type alias Model =
    { areasList : List Area
    , observation : Observation
    , nextId : Int
    , observationTypeList : List ObservationType
    , equipmentList : List Equipment
    , unitList : List Unit
    , materialList : List Material
    , personList : List Person
    , autoState : Menu.State
    , howManyToShow : Int
    , query : String
    , selectedArea : Maybe Area
    , showMenu : Bool
    , csrfToken : String
    }


type Msg
    = AddActivity
    | AddEquipment Activity
    | RemoveEquipment Activity Setup
    | RemoveActivity Activity
    | UpdateActivity Activity String
    | AddMaterial Activity Setup
    | RemoveMaterial Activity Setup MaterialTransaction
    | FoundArea (Result Http.Error (List Area))
    | UpdateComment String
    | UpdateDate String
    | RecieveDate Date
    | GetObservationTypes
    | LoadedObservationTypes (Result Http.Error (List ObservationType))
    | GetEquipment
    | LoadedEquipment (Result Http.Error (List Equipment))
    | GetUnits
    | LoadedUnits (Result Http.Error (List Unit))
    | LoadedObservation (Result Http.Error Observation)
    | GetMaterial
    | LoadedMaterial (Result Http.Error (List Material))
    | LoadedPeople (Result Http.Error (List Person))
    | UpdateMaterial Activity Setup MaterialTransaction String
    | SelectEquipmentName Activity Setup String
    | SelectObservationType ObservationType
    | SetAutoState Menu.Msg
    | Wrap Bool
    | PreviewObsType String
    | SelectObsTypeKeyboard String
    | SelectObsTypeMouse String
    | Reset
    | NoOp
    | SetQuery String
    | RemoveSelectedArea Area
    | DeleteFile File


initialObservation : Observation
initialObservation =
    { obs_date = ""
    , comment = ""
    , areas_as_text = ""
    , areas = []
    , obsType = []
    , activities = Dict.empty
    , files = []
    , id = 0
    }


initialModel : Model
initialModel =
    { areasList = []
    , observation = initialObservation
    , nextId = 0
    , observationTypeList = []
    , equipmentList = []
    , unitList = []
    , materialList = []
    , personList = []
    , autoState = Menu.empty
    , howManyToShow = 20
    , query = ""
    , selectedArea = Nothing
    , showMenu = False
    , csrfToken = ""
    }


init : Flags -> ( Model, Cmd Msg )
init flag =
    ( { initialModel | csrfToken = flag.csrf }
    , case flag.id of
        0 ->
            Cmd.batch
                [ getObservationTypes
                , getAllAreas
                , getPeople
                , getEquipment
                , getUnits
                , getMaterial
                ]

        id ->
            Cmd.batch
                [ getObservation id
                , getObservationTypes
                , getAllAreas
                , getPeople
                , getEquipment
                , getUnits
                , getMaterial
                ]
    )



---- LOADERS and DECODERS


observationDecoder : Decoder Observation
observationDecoder =
    Json.succeed Observation
        |> required "obs_date" Json.string
        |> required "comment" Json.string
        |> required "areas_as_text" Json.string
        |> required "areas" (Json.list areaDecoder)
        |> required "observation_types" (Json.list observationTypeDecoder)
        |> required "activities" (Json.list activityDecoder |> Json.map activityToKeyValue |> Json.map Dict.fromList)
        |> required "files" (Json.list fileDecoder)
        |> required "id" Json.int


activityToKeyValue : List Activity -> List ( Int, Activity )
activityToKeyValue activities =
    List.map (\x -> ( x.id, x )) activities


activityDecoder : Decoder Activity
activityDecoder =
    Json.succeed Activity
        |> required "person" personDecoder
        |> required "setups"
            (Json.list setupDecoder
                |> Json.map setupToKeyValue
                |> Json.map Dict.fromList
            )
        |> required "id" Json.int


fileDecoder : Decoder File
fileDecoder =
    Json.succeed File
        |> required "name" Json.string


setupToKeyValue : List Setup -> List ( Int, Setup )
setupToKeyValue setups =
    List.map (\x -> ( x.id, x )) setups


setupDecoder : Decoder Setup
setupDecoder =
    Json.succeed Setup
        |> required "id" Json.int
        |> required "equipment" equipmentDecoder
        |> required "material_transactions"
            (Json.list materialTransactionDecoder
                |> Json.map transactionToKeyValue
                |> Json.map Dict.fromList
            )


transactionToKeyValue : List MaterialTransaction -> List ( Int, MaterialTransaction )
transactionToKeyValue transactionList =
    List.map (\x -> ( x.id, x )) transactionList



-- infoDecoder : Decoder (Dict Int MaterialTransaction)
-- infoDecoder =
--     map (Dict.map infoToTransaction) (Json.dict materialTransactionDecoder)
--
-- infoToTransaction :  Int ->  MaterialTransaction ->  MaterialTransaction
-- infoToTransaction id transaction =


materialTransactionDecoder : Decoder MaterialTransaction
materialTransactionDecoder =
    Json.succeed MaterialTransaction
        |> required "id" Json.int
        |> required "material" materialDecoder
        |> optional "rate" Json.float 0
        |> required "unit" unitDecoder


getObservation : Int -> Cmd Msg
getObservation id =
    Http.get
        { url = String.concat [ "/observations/", String.fromInt id, ".json" ]
        , expect = Http.expectJson LoadedObservation observationDecoder
        }


personDecoder : Decoder Person
personDecoder =
    Json.succeed Person
        |> required "id" Json.int
        |> required "name" Json.string


getPeople : Cmd Msg
getPeople =
    Http.get
        { url = "/people.json"
        , expect = Http.expectJson LoadedPeople (Json.list personDecoder)
        }


materialDecoder : Decoder Material
materialDecoder =
    Json.succeed Material
        |> required "id" Json.int
        |> required "name" Json.string


getMaterial : Cmd Msg
getMaterial =
    Http.get
        { url = "/materials.json"
        , expect = Http.expectJson LoadedMaterial (Json.list materialDecoder)
        }


unitDecoder : Decoder Unit
unitDecoder =
    Json.succeed Unit
        |> required "id" Json.int
        |> required "name" Json.string


getUnits : Cmd Msg
getUnits =
    Http.get
        { url = "/units.json"
        , expect = Http.expectJson LoadedUnits (Json.list unitDecoder)
        }


equipmentDecoder : Decoder Equipment
equipmentDecoder =
    Json.succeed Equipment
        |> required "id" Json.int
        |> required "name" Json.string
        |> required "use_material" Json.bool


getEquipment : Cmd Msg
getEquipment =
    Http.get
        { url = "/equipment.json"
        , expect = Http.expectJson LoadedEquipment (Json.list equipmentDecoder)
        }


observationTypeDecoder : Decoder ObservationType
observationTypeDecoder =
    Json.map2 ObservationType
        (Json.field "id" Json.int)
        (Json.field "name" Json.string)


getObservationTypes : Cmd Msg
getObservationTypes =
    Http.get
        { url = "/observation_types.json"
        , expect = Http.expectJson LoadedObservationTypes (Json.list observationTypeDecoder)
        }


areaDecoder : Decoder Area
areaDecoder =
    Json.map2 Area
        (Json.field "id" Json.int)
        (Json.field "name" Json.string)


getAllAreas : Cmd Msg
getAllAreas =
    Http.get
        { url = "/areas.json?q="
        , expect = Http.expectJson FoundArea (Json.list areaDecoder)
        }



---- VIEWS


viewActivity : List Person -> List Equipment -> List Unit -> List Material -> Activity -> Html Msg
viewActivity people equipmentList unitList materialList activity =
    Grid.row []
        [ Grid.col [ Col.xs2 ]
            [ select
                [ class "form-control"
                , name
                    (String.concat
                        [ "observation[activities_attributes][", String.fromInt activity.id, "][person_id]" ]
                    )
                , onInput (UpdateActivity activity)
                ]
                (List.map (personSelectItem activity.person) people)
            ]
        , Grid.col [ Col.xs8 ]
            (List.map
                (viewSetup activity
                    equipmentList
                    unitList
                    materialList
                )
                (Dict.values activity.setup)
            )
        , Grid.col [ Col.xs1 ]
            [ Html.button [ customOnClick (AddEquipment activity) ] [ text " Add Equipment" ]
            ]
        , Grid.col [ Col.xs1 ]
            [ Html.button [ customOnClick (RemoveActivity activity) ] [ text "Delete Activity" ]
            ]
        ]


viewSetup : Activity -> List Equipment -> List Unit -> List Material -> Setup -> Html Msg
viewSetup activity equipmentList unitList materialList setup =
    Grid.row []
        [ Grid.col [ Col.xs4 ]
            [ select
                [ class "form-control"
                , name
                    (String.concat
                        [ "observation[activities_attributes]["
                        , String.fromInt activity.id
                        , "][setups_attributes]["
                        , String.fromInt setup.id
                        , "][equipment_id]"
                        ]
                    )
                , onInput
                    (SelectEquipmentName activity
                        setup
                    )
                ]
                (List.map (equipmentSelectItem setup) equipmentList)
            ]
        , Grid.col [ Col.xs8 ]
            [ div []
                (viewMaterials equipmentList
                    unitList
                    materialList
                    activity
                    setup
                )
            , Grid.row []
                [ Grid.col [ Col.xs2 ]
                    [ Html.button [ customOnClick (RemoveEquipment activity setup) ] [ text "Delete Equipment" ]
                    ]
                , Grid.col [ Col.xs1 ] []
                , Grid.col [ Col.xs2 ]
                    [ Html.button [ customOnClick (AddMaterial activity setup) ] [ text " Add Material" ]
                    ]
                ]
            ]
        ]


viewMaterials :
    List Equipment
    -> List Unit
    -> List Material
    -> Activity
    -> Setup
    -> List (Html Msg)
viewMaterials equipmentList unitList materialList activity setup =
    List.map (viewMaterial equipmentList unitList materialList activity setup)
        (Dict.values setup.materials)


viewMaterial :
    List Equipment
    -> List Unit
    -> List Material
    -> Activity
    -> Setup
    -> MaterialTransaction
    -> Html Msg
viewMaterial equipmentList unitList materialList activity setup transaction =
    Grid.row []
        [ Grid.col [ Col.xs4 ]
            [ select
                [ class "form-control"
                , name
                    (String.concat
                        [ "observation[activities_attributes]["
                        , String.fromInt
                            activity.id
                        , "][setups_attributes]["
                        , String.fromInt setup.id
                        , "][material_transactions_attributes]["
                        , String.fromInt
                            transaction.id
                        , "][material_id]"
                        ]
                    )
                , onInput
                    (UpdateMaterial activity
                        setup
                        transaction
                    )
                ]
                (List.map (materialSelectItem transaction) materialList)
            ]
        , Grid.col [ Col.xs4 ]
            [ Html.input
                [ type_ "number"
                , class "form-control"
                , name
                    (String.concat
                        [ "observation[activities_attributes]["
                        , String.fromInt
                            activity.id
                        , "][setups_attributes]["
                        , String.fromInt setup.id
                        , "][material_transactions_attributes]["
                        , String.fromInt
                            transaction.id
                        , "][rate]"
                        ]
                    )
                ]
                []
            ]
        , Grid.col [ Col.xs3 ]
            [ select
                [ class "form-control"
                , name
                    (String.concat
                        [ "observation[activities_attributes]["
                        , String.fromInt
                            activity.id
                        , "][setups_attributes]["
                        , String.fromInt setup.id
                        , "][material_transactions_attributes]["
                        , String.fromInt
                            transaction.id
                        , "][unit_id]"
                        ]
                    )
                ]
                (List.map (unitSelectItem transaction.unit) unitList)
            , Html.text "per acre"
            ]
        , Grid.col [ Col.xs1 ]
            [ Html.i
                [ customOnClick
                    (RemoveMaterial activity setup transaction)
                , class "fa fa-times"
                ]
                []
            ]
        ]


personSelectItem : Person -> Person -> Html msg
personSelectItem selectedPerson person =
    option [ Html.Attributes.selected (person.id == selectedPerson.id), value (String.fromInt person.id) ] [ text person.name ]


materialSelectItem : MaterialTransaction -> Material -> Html msg
materialSelectItem transaction material =
    option [ Html.Attributes.selected (material.id == transaction.material.id), value (String.fromInt material.id) ] [ text material.name ]


equipmentSelectItem : Setup -> Equipment -> Html msg
equipmentSelectItem selected equipment =
    option [ Html.Attributes.selected (equipment.id == selected.equipment.id), value (String.fromInt equipment.id) ] [ text equipment.name ]


unitSelectItem : Unit -> Unit -> Html msg
unitSelectItem selected unit =
    option [ Html.Attributes.selected (unit.id == selected.id), value (String.fromInt unit.id) ] [ text (String.left 10 unit.name) ]


viewSelectedArea : Area -> Html Msg
viewSelectedArea area =
    li [ class "token-input-token-facebook" ]
        [ text area.name
        , span [ class "fa fa-times", onClick (RemoveSelectedArea area) ] []
        ]


view : Model -> Html Msg
view model =
    let
        upDownDecoderHelper : Int -> Json.Decoder ( Msg, Bool )
        upDownDecoderHelper code =
            if code == 38 || code == 40 then
                Json.succeed ( NoOp, True )

            else
                Json.fail "not handling that key"

        upDownDecoder : Json.Decoder ( Msg, Bool )
        upDownDecoder =
            Html.Events.keyCode |> Json.andThen upDownDecoderHelper
    in
    Grid.container []
        [ CDN.fontAwesome
        , Html.form
            [ action "/observations"
            , method "post"
            , Html.Attributes.enctype "multipart/form-data"
            ]
            [ Grid.row []
                [ Grid.col []
                    [ label []
                        [ text "Observation Date"
                        , Html.input
                            [ type_ "text"
                            , name "authenticity_token"
                            , value model.csrfToken
                            , Html.Attributes.hidden True
                            ]
                            []
                        , Html.input
                            [ type_ "date"
                            , name "observation[observation_date]"
                            , class
                                "form-control"
                            , onInput UpdateDate
                            , value model.observation.obs_date
                            ]
                            []
                        ]
                    ]
                ]
            , Grid.row []
                [ Grid.col []
                    [ label []
                        [ text "Comment"
                        , Html.textarea
                            [ name "observation[comment]"
                            , class "form-control"
                            , cols 100
                            , rows 5
                            , onInput UpdateComment
                            , value model.observation.comment
                            ]
                            []
                        ]
                    ]
                ]
            , Grid.row []
                [ Grid.col []
                    [ label []
                        [ text "Areas"
                        , ul [ class "token-input-list-facebook" ]
                            (List.reverse
                                (List.map viewSelectedArea
                                    model.observation.areas
                                )
                            )
                        , Html.input
                            [ type_ "text"
                            , name "area_query"
                            , class "form-control"
                            , onInput SetQuery
                            , Html.Events.preventDefaultOn "keydown" upDownDecoder
                            , Html.Attributes.class "autocomplete-input"
                            , Html.Attributes.autocomplete False
                            , value model.query
                            ]
                            []
                        , if model.showMenu then
                            viewMenu model

                          else
                            Html.div [] []
                        , Html.input
                            [ type_ "text"
                            , name "observation[areas_as_text]"
                            , Html.Attributes.hidden True
                            , value model.observation.areas_as_text
                            ]
                            []
                        ]
                    ]
                ]
            , obsTypeCheckboxes model.observation.obsType model.observationTypeList
            , Grid.row []
                [ Grid.col []
                    (List.map
                        (viewActivity model.personList
                            model.equipmentList
                            model.unitList
                            model.materialList
                        )
                        (Dict.values model.observation.activities)
                    )
                ]
            , Grid.row []
                [ Grid.col []
                    [ Html.button [ customOnClick AddActivity ] [ text "Add Activity" ]
                    ]
                ]
            , Grid.row [ Row.attrs [ class "mt-2" ] ]
                [ Grid.col []
                    [ label []
                        [ input
                            [ type_ "file"
                            , class "form-control-file"
                            , name "observation[notes][]"
                            , Html.Attributes.multiple True
                            ]
                            []
                        ]
                    ]
                ]
            , Grid.row []
                [ Grid.col [ Col.xs10 ]
                    [ ul [] (List.map viewFiles model.observation.files)
                    ]
                ]
            , Grid.row []
                [ Grid.col [ Col.xs2, Col.offsetXs8 ]
                    [ button
                        [ class "btn btn-primary btn-lg"
                        , Html.Attributes.disabled (modelValid model.observation)
                        ]
                        [ text "Submit" ]
                    ]
                ]
            ]
        ]


viewMenu : Model -> Html.Html Msg
viewMenu model =
    Html.div [ Html.Attributes.class "autocomplete-menu" ]
        [ Html.map SetAutoState <|
            Menu.view viewConfig
                model.howManyToShow
                model.autoState
                (acceptableAreas model.query model.areasList)
        ]


viewArea : Area -> Html msg
viewArea area =
    li [] [ text area.name ]


obsTypeCheckboxes : List ObservationType -> List ObservationType -> Html Msg
obsTypeCheckboxes myObsTypes list =
    let
        length =
            floor (toFloat (List.length list) / 3)
    in
    Grid.row []
        [ Grid.col []
            (List.take length list
                |> List.map (obsTypeCheckbox myObsTypes)
            )
        , Grid.col []
            (List.take (length * 2) list
                |> List.drop length
                |> List.map (obsTypeCheckbox myObsTypes)
            )
        , Grid.col []
            (List.drop (length * 2) list
                |> List.map (obsTypeCheckbox myObsTypes)
            )
        ]


obsTypeCheckbox : List ObservationType -> ObservationType -> Html Msg
obsTypeCheckbox myObsTypes obstype =
    div [ class "form-check" ]
        [ label [ class "form-check-label" ]
            [ input
                [ type_ "checkbox"
                , name "observation[observation_type_ids][]"
                , value
                    (String.fromInt obstype.id)
                , class "form-check-input"
                , Html.Attributes.checked (List.any (\x -> x.id == obstype.id) myObsTypes)
                , customOnClick (SelectObservationType obstype)
                ]
                []
            , text obstype.name
            ]
        ]


viewFiles : File -> Html Msg
viewFiles file =
    li []
            [ input
                [ type_ "hidden"
                , value file.name
                , Html.Attributes.multiple True
                ]
                []
            , text file.name
            , span  [class "fa fa-times", onClick (DeleteFile file)] []
            ]


viewConfig : Menu.ViewConfig ObservationType
viewConfig =
    let
        customizedLi keySelected mouseSelected person =
            { attributes =
                [ Html.Attributes.classList
                    [ ( "autocomplete-item", True )
                    , ( "key-selected", keySelected || mouseSelected )
                    ]
                , Html.Attributes.id person.name
                ]
            , children = [ Html.text person.name ]
            }
    in
    Menu.viewConfig
        { toId = .name
        , ul = [ Html.Attributes.class "autocomplete-list" ]
        , li = customizedLi
        }



--- HELPERS


customOnClick : msg -> Attribute msg
customOnClick msg =
    preventDefaultOn "click" (Json.map alwaysPreventDefault (Json.succeed msg))


alwaysPreventDefault : msg -> ( msg, Bool )
alwaysPreventDefault msg =
    ( msg, True )


modelValid : Observation -> Bool
modelValid observation =
    String.isEmpty observation.obs_date
        || String.isEmpty observation.comment
        || List.length observation.obsType
        == 0



--- SETTERS


nextId : Int -> Int
nextId id =
    id + 1


addSetup : Equipment -> Int -> Activity -> Activity
addSetup equipment id activity =
    let
        setup =
            Setup id equipment Dict.empty
    in
    { activity | setup = Dict.insert setup.id setup activity.setup }


updateSetup : Activity -> Setup -> Activity
updateSetup activity setup =
    { activity
        | setup =
            Dict.insert setup.id
                setup
                activity.setup
    }


removeSetupWithId : Int -> Activity -> Activity
removeSetupWithId id activity =
    { activity | setup = Dict.remove id activity.setup }


removeSetup : Activity -> Setup -> Activity
removeSetup activity setup =
    { activity | setup = Dict.remove setup.id activity.setup }


updateEquipment : Dict Int Activity -> Int -> Int -> Equipment -> Dict Int Activity
updateEquipment activities activity_id setup_id equipment =
    case Dict.get activity_id activities of
        Just activity ->
            let
                newActivity =
                    activity
                        |> removeSetupWithId setup_id
                        |> addSetup equipment setup_id
            in
            Dict.insert newActivity.id newActivity activities

        Nothing ->
            activities


addMaterial : Dict Int Activity -> Int -> Int -> Material -> Unit -> Int -> Dict Int Activity
addMaterial activities activity_id setup_id material unit id =
    let
        transaction =
            MaterialTransaction id material 0 unit
    in
    case Dict.get activity_id activities of
        Just activity ->
            case Dict.get setup_id activity.setup of
                Just setup ->
                    let
                        newSetup =
                            { setup
                                | materials =
                                    Dict.insert transaction.id transaction setup.materials
                            }

                        newActivity =
                            updateSetup activity newSetup
                    in
                    Dict.insert newActivity.id newActivity activities

                Nothing ->
                    activities

        Nothing ->
            activities


removeMaterialFromSetup : Setup -> Int -> Setup
removeMaterialFromSetup setup transaction_id =
    { setup | materials = Dict.remove transaction_id setup.materials }


removeMaterial : Dict Int Activity -> Int -> Int -> Int -> Dict Int Activity
removeMaterial activities activity_id setup_id transaction_id =
    case Dict.get activity_id activities of
        Just activity ->
            case Dict.get setup_id activity.setup of
                Just setup ->
                    let
                        newActivity =
                            removeMaterialFromSetup setup transaction_id
                                |> updateSetup activity
                    in
                    Dict.insert newActivity.id newActivity activities

                Nothing ->
                    activities

        Nothing ->
            activities


updateMaterial : Dict Int Activity -> Int -> Int -> Int -> Material -> Dict Int Activity
updateMaterial activities activity_id setup_id transaction_id material =
    case Dict.get activity_id activities of
        Just activity ->
            case Dict.get setup_id activity.setup of
                Just setup ->
                    case Dict.get transaction_id setup.materials of
                        Just transaction ->
                            let
                                newTransaction =
                                    { transaction | material = material }

                                newSetup =
                                    { setup
                                        | materials =
                                            Dict.insert transaction.id
                                                newTransaction
                                                setup.materials
                                    }

                                newActivity =
                                    updateSetup activity newSetup
                            in
                            Dict.insert newActivity.id newActivity activities

                        Nothing ->
                            activities

                Nothing ->
                    activities

        Nothing ->
            activities


removeEquipment : Observation -> Activity -> Setup -> Observation
removeEquipment observation activity setup =
    let
        newActivity =
            removeSetup activity setup
    in
    { observation
        | activities =
            Dict.insert newActivity.id
                newActivity
                observation.activities
    }



--- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddActivity ->
            let
                newActivity =
                    { person = Person 0 "", setup = Dict.empty, id = model.nextId }

                newActivities =
                    Dict.insert newActivity.id newActivity model.observation.activities

                obs =
                    model.observation

                newObservation =
                    { obs
                        | activities =
                            Dict.insert newActivity.id newActivity obs.activities
                    }
            in
            ( { model
                | observation = newObservation
                , nextId = nextId model.nextId
              }
            , Cmd.none
            )

        RemoveActivity activity ->
            let
                obs =
                    model.observation

                newObservation =
                    { obs | activities = Dict.remove activity.id obs.activities }
            in
            ( { model | observation = newObservation }, Cmd.none )

        UpdateActivity activity value ->
            let
                obs =
                    model.observation

                newActivity =
                    case Dict.get activity.id model.observation.activities of
                        Just current ->
                            { current
                                | person =
                                    getPersonAtId model.personList
                                        value
                            }

                        Nothing ->
                            activity

                newObservation =
                    { obs | activities = Dict.insert newActivity.id newActivity obs.activities }
            in
            ( { model | observation = newObservation }, Cmd.none )

        AddEquipment activity ->
            let
                obs =
                    model.observation

                equipment =
                    Maybe.withDefault (Equipment 0 "" True) (List.head model.equipmentList)

                newActivity =
                    addSetup equipment model.nextId activity

                newObservation =
                    { obs
                        | activities =
                            Dict.insert newActivity.id
                                newActivity
                                obs.activities
                    }
            in
            ( { model
                | observation = newObservation
                , nextId = nextId model.nextId
              }
            , Cmd.none
            )

        RemoveEquipment activity setup ->
            let
                newObservation =
                    removeEquipment model.observation activity setup
            in
            ( { model | observation = newObservation }, Cmd.none )

        AddMaterial activity setup ->
            let
                obs =
                    model.observation

                material =
                    Maybe.withDefault (Material 0 "dummy") (List.head model.materialList)

                unit =
                    Maybe.withDefault (Unit 0 "dummy") (List.head model.unitList)

                newActivities =
                    addMaterial obs.activities
                        activity.id
                        setup.id
                        material
                        unit
                        model.nextId

                newObservation =
                    { obs | activities = newActivities }
            in
            ( { model
                | observation = newObservation
                , nextId = nextId model.nextId
              }
            , Cmd.none
            )

        RemoveMaterial activity equipment material ->
            let
                obs =
                    model.observation

                newObservation =
                    { obs
                        | activities =
                            removeMaterial obs.activities
                                activity.id
                                equipment.id
                                material.id
                    }
            in
            ( { model | observation = newObservation }, Cmd.none )

        UpdateMaterial activity setup transaction value ->
            let
                obs =
                    model.observation

                myMaterial =
                    List.filter
                        (\x ->
                            String.fromInt x.id == value
                        )
                        model.materialList
                        |> List.head

                newActivities =
                    case myMaterial of
                        Just material ->
                            updateMaterial obs.activities
                                activity.id
                                setup.id
                                transaction.id
                                material

                        Nothing ->
                            obs.activities

                newObservation =
                    { obs | activities = newActivities }
            in
            ( { model | observation = newObservation }, Cmd.none )

        SelectObservationType obstype ->
            let
                obs =
                    model.observation

                newObservation =
                    { obs | obsType = obstype :: obs.obsType }
            in
            ( { model | observation = newObservation }, Cmd.none )

        SelectEquipmentName activity equipment value ->
            let
                equipment_id =
                    Maybe.withDefault 0 (String.toInt value)

                newEquipment =
                    List.filter (\x -> x.id == equipment_id) model.equipmentList
                        |> List.head
            in
            case newEquipment of
                Just equip ->
                    let
                        obs =
                            model.observation

                        activities =
                            updateEquipment obs.activities activity.id equipment.id equip

                        newObservation =
                            { obs | activities = activities }
                    in
                    ( { model | observation = newObservation }, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        FoundArea result ->
            case result of
                Ok data ->
                    ( { model | areasList = data }, Cmd.none )

                Err error ->
                    ( model, Cmd.none )

        UpdateComment comment ->
            let
                obs =
                    model.observation

                newObservation =
                    { obs | comment = comment }
            in
            ( { model | observation = newObservation }, Cmd.none )

        UpdateDate date ->
            let
                obs =
                    model.observation

                newObservation =
                    { obs | obs_date = date }
            in
            ( { model | observation = newObservation }, Cmd.none )

        RecieveDate date ->
            let
                obs =
                    model.observation

                newObservation =
                    { obs | obs_date = Date.toIsoString date }
            in
            ( { model | observation = newObservation }, Cmd.none )

        GetObservationTypes ->
            ( model, getObservationTypes )

        LoadedObservationTypes result ->
            case result of
                Ok data ->
                    ( { model | observationTypeList = data }, Cmd.none )

                Err error ->
                    ( model, Cmd.none )

        LoadedPeople result ->
            case result of
                Ok data ->
                    ( { model | personList = data }, Cmd.none )

                Err error ->
                    ( model, Cmd.none )

        LoadedObservation result ->
            case result of
                Ok data ->
                    -- merge the new data with potentially old data?
                    ( { model | observation = data }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )

        GetEquipment ->
            ( model, getEquipment )

        LoadedEquipment result ->
            case result of
                Ok data ->
                    ( { model | equipmentList = data }, Cmd.none )

                Err error ->
                    ( model, Cmd.none )

        GetUnits ->
            ( model, getUnits )

        LoadedUnits result ->
            case result of
                Ok data ->
                    ( { model | unitList = data }, Cmd.none )

                Err error ->
                    ( model, Cmd.none )

        GetMaterial ->
            ( model, getMaterial )

        LoadedMaterial result ->
            case result of
                Ok data ->
                    ( { model | materialList = data }, Cmd.none )

                Err error ->
                    ( model, Cmd.none )

        SetAutoState autoMsg ->
            let
                ( newState, maybeMsg ) =
                    Menu.update updateConfig
                        autoMsg
                        model.howManyToShow
                        model.autoState
                        (acceptableAreas model.query model.areasList)

                newModel =
                    { model | autoState = newState }
            in
            maybeMsg
                |> Maybe.map (\updateMsg -> update updateMsg newModel)
                |> Maybe.withDefault ( newModel, Cmd.none )

        Wrap toTop ->
            case model.selectedArea of
                Just area ->
                    update Reset model

                Nothing ->
                    if toTop then
                        ( { model
                            | autoState =
                                Menu.resetToLastItem updateConfig
                                    (acceptableAreas model.query model.areasList)
                                    model.howManyToShow
                                    model.autoState
                            , selectedArea =
                                acceptableAreas model.query model.areasList
                                    |> List.take model.howManyToShow
                                    |> List.reverse
                                    |> List.head
                          }
                        , Cmd.none
                        )

                    else
                        ( { model
                            | autoState =
                                Menu.resetToFirstItem updateConfig
                                    (acceptableAreas model.query model.areasList)
                                    model.howManyToShow
                                    model.autoState
                            , selectedArea =
                                acceptableAreas model.query model.areasList
                                    |> List.take model.howManyToShow
                                    |> List.head
                          }
                        , Cmd.none
                        )

        PreviewObsType id ->
            ( { model
                | selectedArea =
                    Just (getAreaAtId model.areasList id)
              }
            , Cmd.none
            )

        SelectObsTypeKeyboard id ->
            let
                newModel =
                    setQuery model id
                        |> resetMenu
            in
            ( newModel, Cmd.none )

        SelectObsTypeMouse id ->
            let
                newModel =
                    setQuery model id
                        |> resetMenu
            in
            ( newModel, Cmd.none )

        Reset ->
            ( { model
                | autoState = Menu.reset updateConfig model.autoState
                , selectedArea = Nothing
              }
            , Cmd.none
            )

        NoOp ->
            ( model, Cmd.none )

        SetQuery newQuery ->
            let
                showMenu =
                    not (List.isEmpty (acceptableAreas newQuery model.areasList))
            in
            ( { model
                | query = newQuery
                , showMenu = showMenu
                , selectedArea = Nothing
              }
            , Cmd.none
            )

        RemoveSelectedArea area ->
            let
                obs =
                    model.observation

                intermediateObservation =
                    { obs
                        | areas =
                            List.filter (\x -> x.id /= area.id)
                                obs.areas
                    }

                newObservation =
                    { intermediateObservation
                        | areas_as_text =
                            String.concat
                                (List.map (\x -> x.name) intermediateObservation.areas)
                    }

                newModel =
                    { model | observation = newObservation }
            in
            ( newModel, Cmd.none )

        DeleteFile file ->
          let
              obs = model.observation
              newObservation = { obs | files = List.filter (\x -> x.name /=
                file.name) obs.files }
          in
            ({ model | observation = newObservation }, Cmd.none)

updateConfig : Menu.UpdateConfig Msg ObservationType
updateConfig =
    Menu.updateConfig
        { toId = .name
        , onKeyDown =
            \code maybeId ->
                if code == 38 || code == 40 then
                    Maybe.map PreviewObsType maybeId

                else if code == 13 then
                    Maybe.map SelectObsTypeKeyboard maybeId

                else
                    Just Reset
        , onTooLow = Just (Wrap False)
        , onTooHigh = Just (Wrap True)
        , onMouseEnter = \id -> Just (PreviewObsType id)
        , onMouseLeave = \_ -> Nothing
        , onMouseClick = \id -> Just (SelectObsTypeMouse id)
        , separateSelections = False
        }


setQuery : Model -> String -> Model
setQuery model id =
    let
        area =
            getAreaAtId model.areasList id
    in
    case List.member area model.observation.areas of
        False ->
            let
                obs =
                    model.observation

                newObservation =
                    { obs
                        | areas_as_text =
                            String.trimLeft
                                (String.concat
                                    [ obs.areas_as_text
                                    , " "
                                    , .name area
                                    ]
                                )
                        , areas = area :: obs.areas
                    }
            in
            { model
                | observation = newObservation
                , query = ""
                , selectedArea = Just area
            }

        True ->
            { model | query = "" }


getAreaAtId : List Area -> String -> Area
getAreaAtId areas id =
    List.filter (\area -> area.name == id) areas
        |> List.head
        |> Maybe.withDefault (Area 0 "")


getPersonAtId : List Person -> String -> Person
getPersonAtId people id =
    List.filter (\person -> String.fromInt person.id == id) people
        |> List.head
        |> Maybe.withDefault (Person 0 "")


acceptableAreas : String -> List Area -> List Area
acceptableAreas query areas =
    let
        lowerQuery =
            String.toLower query
    in
    List.filter (String.contains lowerQuery << String.toLower << .name) areas


resetMenu : Model -> Model
resetMenu model =
    { model
        | autoState = Menu.empty
        , showMenu = False
    }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map SetAutoState Menu.subscription


main =
    Browser.element
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }
