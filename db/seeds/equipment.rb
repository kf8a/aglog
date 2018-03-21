# frozen_string_literal: true

company = Company.find_or_create_by(name: 'lter')

Equipment.find_or_create_by(name: 'John Deere 5220 Tractor', is_tractor: true,
                            company_id: company.id)
Equipment.find_or_create_by(name: 'Gandy Air Seeder', use_material: true,
                            company_id: company.id)
Equipment.find_or_create_by(name: 'John Deere 7520 Tractor',
                            is_tractor: true, company_id: company.id)
Equipment.find_or_create_by(name: 'John Deere 714 Chisel plow',
                            company_id: company.id)
Equipment.find_or_create_by(name: 'John Deere 7420a Tractor',
                            is_tractor: true, company_id: company.id)
Equipment.find_or_create_by(name: 'John Deere 115 flail shredder',
                            company_id: company.id)
Equipment.find_or_create_by(name: 'Top Air Sprayer', use_material: true,
                            company_id: company.id)
Equipment.find_or_create_by(name: 'John Deere 726 soil finisher')
Equipment.find_or_create_by(name: 'John Deere 1730 Maxemerge Plus Planter',
                            use_material: true, company_id: company.id)
Equipment.find_or_create_by(name: 'Rotary Hoe', company_id: company.id)
Equipment.find_or_create_by(name: 'Hay tedder', company_id: company.id)
Equipment.find_or_create_by(name: 'John Deere 2155 Tractor', is_tractor: true,
                            company_id: company.id)
Equipment.find_or_create_by(name: 'New Holland Baler', use_material: true,
                            company_id: company.id)
Equipment.find_or_create_by(name: "John Deere 10' brushhog mower",
                            company_id: company.id)
Equipment.find_or_create_by(name: 'Willmar spreader', use_material: true,
                            company_id: company.id)
Equipment.find_or_create_by(name: 'John Deere 6420 Tractor', is_tractor: true,
                            company_id: company.id)
Equipment.find_or_create_by(name: 'John Deere 6 Row Corn Harvester',
                            is_tractor: true, company_id: company.id)
