# give me all of corn applied to treatment 4 each year

select year(observation.date), sum(setup.amount) from setup, activity, 
observation, area, lot, material
where 
activity.observation_id = observation.id and
area_observation.observation_id = observation.id and
area_observaton.area_id =  area.id and
area.treatment = 4 and
setup.activity_id = activity.id and
setup.lot_id = lot.id
and lot.material_id = material.id
and material.name = 'corn'
group by year(observation.date)

# give me the cost of the material applied to treatment 4
select year(obs_date), sum(setup.amount * lot.cents/lot.amount) from 
setup, activity, 
observation, area, lot, material
where 
activity.observation_id = observation.id and
area_observation.observation_id = observation.id and
area_observaton.area_id =  area.id and
area.treatment = 4 and
setup.activity_id = activity.id and
setup.lot_id = lot.id
and lot.material_id = material.id
group by year(observation.date)
 
