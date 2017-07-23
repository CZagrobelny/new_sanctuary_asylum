#Admin User
User.create(first_name: 'Admin', last_name: 'Admin', email: 'admin@example.com', phone: '888 888 8888', password: 'password', password_confirmation: 'password', invitation_accepted_at: Time.now, volunteer_type: 1, role: 1)

#Volunteer User
User.create(first_name: 'Volunteer', last_name: 'Volunteer', email: 'volunteer@example.com', phone: '888 888 8888', password: 'password', password_confirmation: 'password', invitation_accepted_at: Time.now, volunteer_type: 1, role: 0)

#Some additional volunteer users
User.create(first_name: 'Zadie', last_name: 'Smith', email: 'zadie.smith@example.com', phone: '888 888 8888', password: 'password', password_confirmation: 'password', invitation_accepted_at: Time.now, volunteer_type: 1, role: 0)
User.create(first_name: 'Virginia', last_name: 'Woolf', email: 'virginia.woolf@example.com', phone: '888 888 8888', password: 'password', password_confirmation: 'password', invitation_accepted_at: Time.now, volunteer_type: 1, role: 0)

#Friends
Friend.create(first_name: 'Amelia', last_name: 'Earhart', a_number: '430580439')
Friend.create(first_name: 'Lynn', last_name: 'Nottage', a_number: '679854093')

#Lawyers
Lawyer.create(first_name: 'Michelle', last_name: 'Obama')
Lawyer.create(first_name: 'Arrabella', last_name: 'Mansfield')
Lawyer.create(first_name: 'Amal', last_name: 'Clooney')

#Locations
Location.create(name: '26 Federal Plaza')

#Judges
Judge.create(first_name: 'Ruth', last_name: 'Bader Ginsburg')
Judge.create(first_name: 'Sonia', last_name: 'Sotomayor')
Judge.create(first_name: 'Elena', last_name: 'Kagan')

#Events
Event.create(location: Location.first, 
             event_catagory: 'asylum_workshop', 
             date: Time.now + 3.days, 
             title: 'Popular Asylum Workshop') 

Event.create(location: Location.first, 
             event_catagory: 'accompaniment_training', 
             date: Time.now + 2.days, 
             title: 'Trainging for Everyone') 
