person = Person.find_or_create_by(:given_name => 'Joe', :sur_name => 'Simmons')
company = Company.first
Membership.create(person_id: person.id, company_id: company.id, default_company: true)
