import sys
import json
import random

# --ändra dessa för varje event--

# antal platser på eventet, inklusiva interna anmodningar (ex fös, sångförmän, ledning)
nbr_of_spots = 300

# 'Mentor group' eller 'Mission group'
type_of_event = 'Mentor group'

# Vilka grupper som ska anmodas, 'Föset', 'Ledningen' eller 'Sångförmän'
prioritizations = ['Föset', 'Ledningen', 'Sångförmän']

# Antalet garanterade faddrar per grupp
nbr_of_guarantee_mentors = 1

# som det står på hemsidan, utan å, ä & ö
event_name = 'nollegasque-efterslapp'

# priser för eventet
price_ticket = 200
price_alcohol = 150
price_alcoholfree = 100

# --ändra vid stora förändringar--

mentor_groups = {
    'Harry(x) Plotter': 0,
    'Gaussip Girls': 0,
    'Fast and the Fouriers': 0,
    'Alice i Underrummet': 0,
    'SI-th units': 0,
    'Quantum Tarantino': 0,
    'Shrekvationssystemet': 0,
    'Bumπbjörnarna': 0,
    'Blixten Maclaurin': 0,
    'ππ-långstrump': 0,
    'Knatte Fnatte och Matte': 0,
    'πngu1': 0,
    'Funktionstein': 0,
    'Stig Hilberts SÄLGskapsresa': 0,
    'Hookes Bookus': 0
}

mission_groups = {
    'Aristokattapulterna / Ballongistapulten': 0,
    'The-cheerbaccas / Cheer': 0,
    'Interstellør / Flying': 0,
    'Maxwell-verstappen / lådbilen': 0,
    'Wizard-of-cos / Nollefilmen': 0,
    'Sex and the sittning / Nollesexet': 0,
    'Lord-of-the-olympic-rings /Nollympiaden': 0,
    'Misconception-impossible / Överföshinderbanan': 0,
    'Tautanic / Regattan': 0,
    'Djungelbokens-spexvationer / Revyn': 0,
    'Dampth-wader / Waterloo': 0
}

nbr_of_mentor_groups = len(mentor_groups)
nbr_of_mission_groups = len(mission_groups)

management = [
    'Ordförande',
    'Vice ordförande',
    'Styrelsepreses',
    'Sekreterare',
    'Kassör',
    'Styrelseledamot'
    'Överfös',
    'Kulturminister',
    'Näringslivsansvarig',
    'Projektledare FARAD'
    'Cafémästare',
    'Vice cafémästare',
    'Sanningsminister',
    'Samvetsmästare',
    'Prylmästare',
    'Sexmästare',
    'Utbildningsminister',
    'Spindelförman',
    'Studier\u00e5dsordf\u00f6rande f\u00f6r teknisk fysik',
    'Studier\u00e5dsordf\u00f6rande f\u00f6r teknisk matematik'
    'Studier\u00e5dsordf\u00f6rande f\u00f6r teknisk nanovetenskap',
]

foset = ['Överfös', 'Cofös', 'Cofös med bokföringsansvar']



prioritized_one = [
    'Reisemeister',
    'Bilförman',
    'Idrottsförman',
    'Sektionshärold',
    'Revisor',
    'Bokförman',
    'Valberedningsledamot',
    'Sångarstridsförman',
    'von Tänen-redaktör',
    'Likabehandlingsordförande',
    'Kardinalbagge'
]

prioritized_posts = []
if 'Ledningen' in prioritizations: prioritized_posts.extend(management)
if 'Föset' in prioritizations: prioritized_posts.extend(foset)
if 'Sångförmän' in prioritizations: prioritized_posts.append('Sångförman')

# --ändra inget här under--

if type_of_event == 'Mentor group': 
    nbr_of_groups = nbr_of_mentor_groups
    groups = mentor_groups
elif type_of_event == 'Mission group': 
    nbr_of_groups = nbr_of_mission_groups
    groups = mission_groups
else: raise ValueError('Expexted Mentor group or Mission group as type of event')

fileName = 'anmalda_till_' + event_name + '.csv'
fileName = fileName.replace(' ', '-')

sys.stdin.reconfigure(encoding='utf-8')
sys.stdout.reconfigure(encoding='utf-8')

with open('user_dic.json', 'r', encoding='UTF-8-SIG') as f: group_dictionary = json.load(f)

with open('post_dic.json', 'r', encoding='UTF-8-SIG') as f: post_dictionary = json.load(f)

with open(fileName, 'r', encoding='UTF-8', newline='') as f:

    mentor_list = []
    mentee_list = []
    other_list = []
    prioritized_list = []

    f.readline()

    # parse the csv file of the sign ups
    for line in f:

        # handles commas in the csv data
        quotes = False
        for idx, ch in enumerate(line):
            if ch == '"':
                quotes = not quotes
            if ch == ',' and quotes:
                line = line[:idx] + ';' + line[idx + 1:]    

        # split the data in variables
        name = line.split(',')[0]
        given_user_type = line.split(',')[1]
        group = line.split(',')[2]
        foodpref = line.split(',')[3]
        answer = line.split(',')[4]
        mail = line.split(',')[5]
        timestamp = line.split(',')[6]
        
        try:
            alcohol_package = line.split(',')[7][:-1]
        except:
            alcohol_package = 'Inget'
            timestamp = timestamp[:-1]

        # check if person wants alchol package or not
        if alcohol_package == 'Alkohol':
            price = price_ticket + price_alcohol
        elif alcohol_package == 'Alkoholfritt':
            price = price_ticket + price_alcoholfree
        else:
            price = price_ticket

        # retrieves data from dict of posts to check for priorities
        if mail in post_dictionary:
            user_data = post_dictionary[mail]
            
            if any(post in prioritized_posts for post in user_data['Posts']):
                if mail in group_dictionary:
                    for g in group_dictionary[mail]['Groups']:
                        if g in groups:
                            group = g
                            type_of_user = 'Fadder'
                            groups[group] += int(price - price_ticket)
                            break
                        
                        else:
                            if group == '':
                                group = f'Anmodad ({user_data["Posts"]})'
                            type_of_user = 'Anmodad'
                        
                else:
                    if group == '':
                        group = f'Anmodad ({user_data["Posts"]})'
                    type_of_user = 'Anmodad'
                
                prioritized_list.append([name, mail, foodpref, type_of_user, given_user_type, group, answer, str(price - price_ticket), timestamp])
                nbr_of_spots += -1
                continue

        # retrieves data from dict of mentor groups
        if mail in group_dictionary:
            user_data = group_dictionary[mail]

            for g in user_data['Groups']:
                if g in groups:
                    group = g
                    break

            if user_data['Type'] == 'mentor' and any(group in groups for group in user_data['Groups']):
                mentor_list.append([name, mail, foodpref, 'Fadder', given_user_type, group, answer, str(price), timestamp])
            
            elif user_data['Type'] == 'mentee':
                mentee_list.append([name, mail, foodpref, 'Nolla', given_user_type, group, answer, str(price), timestamp])
            
            else:
                other_list.append([name, mail, foodpref, 'Övrigt', given_user_type, group, answer, str(price), timestamp])

        else:
            other_list.append([name, mail, foodpref, 'Övrigt', given_user_type, group, answer, str(price), timestamp])
            user_data = None

# kolla om det får plats åtminstone en fadder per grupp
if nbr_of_spots < nbr_of_groups and nbr_of_spots > 0:
    nbr_of_spots = 0

# fördela garantifaddrar
chosen_mentors = []
prioritized_mentors = []
chosen_groups = []

for group in groups:
    mlist = [i for i in mentor_list if i[5] == group]
    plist = []
    for i in prioritized_list:
        if i[5] == group:
            plist.append(i)
            prioritized_mentors.append(i)
            chosen_groups.append(group)

    mlist.extend(plist)
    if len(mlist) < nbr_of_guarantee_mentors:
        print(group + ' har endast ' + str(len(mlist)) + ' anmälda faddrar')
        chosen_groups.extend([group]*(nbr_of_guarantee_mentors - len(mlist)))

if nbr_of_spots < nbr_of_groups * nbr_of_guarantee_mentors:
    new_nbr_of_guarantee_mentors = nbr_of_guarantee_mentors
    for i in range(nbr_of_guarantee_mentors):
        if nbr_of_spots < nbr_of_groups * new_nbr_of_guarantee_mentors:
            new_nbr_of_guarantee_mentors -= 1
    print(f'För få platser för att garantera {nbr_of_guarantee_mentors} faddrar i varje grupp. Ändrar till {new_nbr_of_guarantee_mentors } faddrar per grupp.')
    nbr_of_guarantee_mentors = new_nbr_of_guarantee_mentors

while len(chosen_groups) < nbr_of_groups * nbr_of_guarantee_mentors:
    #print(len(chosen_mentors) + len(prioritized_mentors), nbr_of_groups * nbr_of_guarantee_mentors)
    #(len(chosen_groups))
    idx = random.randint(0, len(mentor_list) - 1)
    if len([i for i in chosen_groups if i == mentor_list[idx][5]]) < nbr_of_guarantee_mentors:
        choice = mentor_list.pop(idx)
        chosen_mentors.append(choice)
        chosen_groups.append(choice[5])
        groups[choice[5]] += int(choice[7])
        nbr_of_spots -= 1

# ge alla nollor plats om det räcker
chosen_mentees = []
if nbr_of_spots > len(mentee_list):
    nbr_of_spots -= len(mentee_list)
    for choice in mentee_list:
        chosen_mentees.append(choice)
        groups[choice[5]] += int(choice[7])
    mentee_list.clear()

# annars slumpa ut dem
else:
    while nbr_of_spots > 0 and len(mentee_list) > 0:
        idx = random.randint(0, nbr_of_spots - 1)
        choice = mentee_list.pop(idx)
        chosen_mentees.append(choice)
        groups[choice[5]] += int(choice[7])
        nbr_of_spots -= 1


# ge alla resterande faddrar plats om det finns platser över
if nbr_of_spots > len(mentor_list):
    nbr_of_spots -= len(mentor_list)
    for choice in mentor_list:
        chosen_mentors.append(choice)
        groups[choice[5]] += int(choice[7])
    mentor_list.clear()

# annars slumpa ut dem
else:
    while nbr_of_spots > 0:
        idx = random.randint(0, nbr_of_spots - 1)
        choice = mentor_list.pop(idx)
        chosen_mentors.append(choice)
        groups[choice[5]] += int(choice[7])
        nbr_of_spots -= 1

with open('platsindelning.csv', 'w', encoding='UTF-8-SIG') as f:
    f.write('Namn, Mail, Matpreferens, Användartyp, Given användartyp, Grupp, Svar, Pris, Anmälningstid \n')
    f.write('antal platser kvar: ' + str(nbr_of_spots) + '\n')

    f.write('\n')
    f.write('-------------------------------------')
    f.write('\n')
    f.write('Personer som fick plats:')
    f.write('\n')
    f.write('-------------------------------------')
    f.write('\n')

    f.write(f'Anmodade: {len(prioritized_list)}\n')
    for priority in prioritized_list:
        for element in priority:
            #print(element)
            f.write(element + ', ')
        f.write('\n')
    
    f.write(f'Faddrar: {len(chosen_mentors)}\n')
    for mentor in chosen_mentors:
        for element in mentor:
            f.write(element + ', ')
        f.write('\n')
    
    f.write(f'Nollor: {len(chosen_mentees)}\n')
    for mentee in chosen_mentees:
        for element in mentee:
            f.write(element + ', ')
        f.write('\n')

    f.write('\n')
    f.write('-------------------------------------')
    f.write('\n')
    f.write('antal nollor som inte fick plats: ' + str(len(mentee_list)) + '\n')
    f.write('-------------------------------------')
    f.write('\n')
    
    for mentee in mentee_list:
        for element in mentee:
            f.write(element + ', ')
        f.write('\n')


    f.write('\n')
    f.write('-------------------------------------')
    f.write('\n')
    f.write('antal faddrar som inte fick plats: ' + str(len(mentor_list)) + '\n')
    f.write('-------------------------------------')
    f.write('\n')

    for mentor in mentor_list:
        for element in mentor:
            f.write(element + ', ')
        f.write('\n')
    
    f.write('\n')
    f.write('-------------------------------------')
    f.write('\n')
    f.write('antal övriga kvar att fördela: ' + str(len(other_list)) + '\n')
    f.write('-------------------------------------')
    f.write('\n')

    for other in other_list:
        for element in other:
            f.write(element + ', ')
        f.write('\n')

    f.write('\n')
    f.write('-------------------------------------')
    f.write('\n')
    f.write('Betallista: \n')
    f.write('-------------------------------------')
    f.write('\n')

    for group in groups.keys():
        f.write(f'{group}, {str(groups[group])} \n')

    for person in prioritized_list:
        if person[5] not in groups:
            f.write(f'{person[0]}, {person[7]} \n')