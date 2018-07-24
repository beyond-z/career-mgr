industries = [
  'Accounting', 'Advertising', 'Aerospace', 'Banking', 'Beauty / Cosmetics', 'Biotechnology', 'Business', 
  'Chemical', 'Communications', 'Computer Engineering', 'Computer Hardware', 'Education', 'Electronics', 
  'Employment / Human Resources', 'Energy', 'Fashion', 'Film', 'Financial Services', 'Fine Arts', 
  'Food & Beverage', 'Health', 'Information Technology', 'Insurance', 'Journalism / News / Media', 'Law', 
  'Management / Strategic Consulting', 'Manufacturing', 'Medical Devices & Supplies', 'Performing Arts', 
  'Pharmaceutical', 'Public Administration', 'Public Relations', 'Publishing', 'Marketing', 'Real Estate', 
  'Sports', 'Technology', 'Telecommunications', 'Tourism', 'Transportation / Travel', 'Writing'
]
    
industries.sort.each do |name|
  Industry.find_or_create_by name: name
end

interests = [
  'Accounting', 'African American Studies', 'African Studies', 'Agriculture', 'American Indian Studies', 
  'American Studies', 'Architecture', 'Asian American Studies', 'Asian Studies', 'Dance', 'Visual Arts', 
  'Theater', 'Music', 'English / Literature', 'Film', 'Foreign Language', 'Graphic Design', 'Philosophy', 
  'Religion', 'Business', 'Marketing', 'Actuarial Science', 'Hospitality', 'Human Resources', 'Real Estate', 
  'Health', 'Public Health', 'Medicine', 'Nursing', 'Gender Studies', 'Urban Studies', 'Latin American Studies', 
  'European Studies', 'Gay and Lesbian Studies', 'Latinx Studies', 'Women’s Studies', 'Education', 'Psychology', 
  'Child Development', 'Computer Science', 'History', 'Biology', 'Cognitive Science', 'Human Biology', 
  'Diversity Studies', 'Marine Sciences', 'Maritime Studies', 'Math', 'Nutrition', 'Sports and Fitness', 
  'Law / Legal Studies', 'Military', 'Public Administration', 'Social Work', 'Criminal Justice', 'Theology', 
  'Equestrian Studies', 'Food Science', 'Urban Planning', 'Art History', 'Interior Design', 'Landscape Architecture', 
  'Chemistry', 'Physics', 'Chemical Engineering', 'Software Engineering', 'Industrial Engineering', 
  'Civil Engineering', 'Electrical Engineering', 'Mechanical Engineering', 'Biomedical Engineering', 
  'Computer Hardware Engineering', 'Anatomy', 'Ecology', 'Genetics', 'Neurosciences', 'Communications', 
  'Animation', 'Journalism', 'Information Technology', 'Aerospace', 'Geography', 'Statistics', 
  'Environmental Studies', 'Astronomy', 'Public Relations', 'Library Science', 'Anthropology', 'Economics', 
  'Criminology', 'Archaeology', 'Cartography', 'Political Science', 'Sociology', 'Construction Trades', 
  'Culinary Arts', 'Creative Writing'
]

interests.sort.each do |name|
  Interest.find_or_create_by name: name
end

['Unknown', 'Unemployed', 'Quality (Grad School)', 'Quality', 'Part Quality', 'Not Quality', 'Service'].each_with_index do |status, position|
  EmploymentStatus.find_or_create_by! name: status, position: position
end

OpportunityStage.create!([
  {position: 0, probability: 0.01, name: 'notified'},
  {position: 1, probability: 0.05, name: 'interested'},
  {position: 2, probability: 0.0,  name: 'not interested'},
  {position: 3, probability: 0.1,  name: 'applying'},
  {position: 4, probability: 0.15, name: 'application submitted'},
  {position: 5, probability: 0.35, name: 'interview scheduled'},
  {position: 6, probability: 0.55, name: 'interview completed'},
  {position: 7, probability: 0.9,  name: 'offered'},
  {position: 8, probability: 0.95, name: 'accepted'},
  {position: 9, probability: 1.0,  name: 'committed'},
  {position: 10, probability: 0.0,  name: 'rejected'}
])

nlu = Site.find_or_create_by code: 'NLU', name: 'National Louis University'
nlu.update(
  location_attributes: {
    name: 'Chicago Campus',
    contact_attributes: {
      address_1: '122 S Michigan Ave',
      city: 'Chicago', state: 'IL', postal_code: '60603',
      phone: '888-658-8632',
      email: 'nluchicago@nl.edu',
      url: 'http://www.nl.edu'
    }
  }
)

rutgers = Site.find_or_create_by code: 'RU-N', name: "Rutgers University - Newark"
rutgers.update(
  location_attributes: {
    name: 'Office of the Chancellor',
    contact_attributes: {
      address_1: '123 Washington ',
      city: 'Neward', state: 'NJ', postal_code: '07102',
      phone: '973-353-5541',
      url: 'http://www.neward.rutgers.edu'
    }
  }
)

sjsu = Site.find_or_create_by code: 'SJSU', name: 'San Jose State University'
sjsu.update(
  location_attributes: {
    name: 'Campus',
    contact_attributes: {
      address_1: 'One Washington Square',
      city: 'San Jose', state: 'CA', postal_code: '95192',
      phone: '408-924-1000',
      url: 'http://www.sjsu.edu'
    }
  }
)
