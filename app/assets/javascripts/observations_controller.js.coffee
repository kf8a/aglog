app = angular.module 'Aglog', ['ngResource']

app.factory "Observation", ($resource) ->
  $resource("/observations/:id.json", {id: "@id"}, {update: {method: "PUT"}})

@NewCtrl = ($scope, $filter, $resource, $rootElement, Observation ) ->
  # Observation = $resource("/observations/:id.json", {id: "@id"}, {update: {method: "PUT"}})

  id = $rootElement.data('observation-id')
  $scope.obs = Observation.get({id: id})

  $scope.addActivity = ->
    $scope.obs.activities.push({person: null, hours: 0, setups: []})

  $scope.addEquipment = (activity) ->
    activity.setups.push({equipment: null, material_transactions: []})

  $scope.addMaterial = (equipment) ->
    equipment.material_transactions.push({name: null, amount: 0, unit: null})

  $scope.removeMaterial = (equipment, material) ->
    if material.id
      material.destroy = 1
    else
      idx = $.inArray(material, equipment)
      equipment.material_transactions.splice(idx, 1)

  $scope.removeSetup = (activity, setup) ->
    if setup.id
      setup.destroy = 1
    else
      idx = $.inArray(setup, activity.setups)
      activity.setups.splice(idx, 1)

  $scope.removeActivity = (activity) ->
    if activity.id
      activity.destroy = 1
    else
      idx = $.inArray(activity, $scope.obs.activities)
      $scope.obs.activities.splice(idx, 1)
