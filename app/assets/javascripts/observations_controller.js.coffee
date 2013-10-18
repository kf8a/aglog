app = angular.module('Aglog', ['ngResource'])

app.factory "Observation", ($resource) ->
  $resource("/observations/:id.json", {id: "@id"}, {update: {method: "PUT"}})

@NewCtrl = ($scope, $filter, $resource, $rootElement, Observation ) ->
  # Observation = $resource("/observations/:id.json", {id: "@id"}, {update: {method: "PUT"}})

  id = $rootElement.data('observation-id')
  $scope.obs = Observation.get({id: id})

  console.log($scope.obs)

  $scope.areas = [
      {id: '1', text: 'lter', areas: [
        {id: '2', text: 'T1'},
        {id: '3', text: 'T2'},
        {id: '4', text: 'T3'},
        {id: '6', text: 'T4'},
        {id: '7', text: 'T5'},
        {id: '8', text: 'T6'}
      ]},
      {id: '5', text: 'glbrc', areas: [
        {id: '11', text: 'G1'},
        {id: '12', text: 'G2'},
        {id: '13', text: 'G3'},
        {id: '14', text: 'G3R1'},
        {id: '15', text: 'G3R2'},
        {id: '16', text: 'M3 - Switchgrass'},
        {id: '17', text: 'M2 - Prarie' },
        {id: '18', text: 'L2 - Switchgrass'}
      ]},
      {id: '7', text: 'glbrc marginal south', areas: [
        {id: '42', text: 'G8'},
        {id: '43', text: 'G8R1'},
        {id: '44', text: 'G8R2'},
        {id: '45', text: 'G8R3'},
        {id: '46', text: 'G8R4'},
        {id: '47', text: 'G9'},
        {id: '48', text: 'G9R1'},
        {id: '49', text: 'G9R2'},
        {id: '50', text: 'G9R3'},
        {id: '51', text: 'G9R4'},
        {id: '52', text: 'G10'},
        {id: '53', text: 'G10R1'},
        {id: '54', text: 'G10R2'},
        {id: '55', text: 'G10R3'},
        {id: '56', text: 'G10R4'}
      ]}
      {id: '8', text: 'glbrc marginal central', areas: [
        {id: '32', text: 'G9'},
        {id: '33', text: 'G9R1'},
        {id: '34', text: 'G9R2'},
        {id: '35', text: 'G9R3'},
        {id: '36', text: 'G9R4'},
        {id: '37', text: 'G10'},
        {id: '38', text: 'G10R1'},
        {id: '39', text: 'G10R2'},
        {id: '40', text: 'G10R3'},
        {id: '41', text: 'G10R4'}
      ]}
      {id: '9', text: 'glbrc marginal north', areas: [
        {id: '17', text: 'G7'},
        {id: '18', text: 'G7R1'},
        {id: '19', text: 'G7R2'},
        {id: '20', text: 'G7R3'},
        {id: '21', text: 'G7R4'},
        {id: '22', text: 'G8'},
        {id: '23', text: 'G7R1'},
        {id: '24', text: 'G7R2'},
        {id: '25', text: 'G7R3'},
        {id: '25', text: 'G7R4'},
        {id: '27', text: 'G9'},
        {id: '28', text: 'G9R1'},
        {id: '29', text: 'G9R2'},
        {id: '30', text: 'G9R3'},
        {id: '31', text: 'G9R4'}
      ]}
    ]

    $scope.tagsSelection = []
    $scope.tagData = []

    $scope.tagAllOptions = {
      multiple: true,
      data: $scope.tagData,
    }

    $scope.areaTags = ->
      area = $scope.areas.filter (el) -> el.id == $scope.selectedArea
      area[0].areas if area[0]?

    $scope.updateAreaTags = ->
      areaSelect = $('areaSelect')
      $('#areaSelect').select2({multiple: true, data: $scope.areaTags()}).trigger('change')

    $scope.addActivity = ->
      $scope.obs.activities.push({person: null, hours: 0, setups: []})

    $scope.addEquipment = (activity) ->
      activity.setups.push({equipment: null, material_transactions: []})

    $scope.addMaterial = (equipment) ->
      equipment.material_transactions.push({name: null, amount: 0, unit: null})

    $scope.removeMaterial = (equipment, idx) ->
      console.log(equipment)
      equipment.material_transactions.splice(idx, 1)

    $scope.removeEquipment = (activity, idx) ->
      activity.setups.splice(idx, 1)

    $scope.removeActivity = (idx) ->
      $scope.obs.activities.splice(idx, 1)
