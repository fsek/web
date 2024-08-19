import json
import sys
sys.stdin.reconfigure(encoding='utf-8')
sys.stdout.reconfigure(encoding='utf-8')

class dictionary:

    def __init__(self, file_name) -> None:
        self.file_name = file_name
        self.user_dictionary = self.load_file()

    def add_user_with_post(self, mail: str, name:str, post:str):
        if mail == None or name == None or post == None:
            raise TypeError('expected mail, name and post')
        
        if mail not in self.user_dictionary:
            self.user_dictionary[mail] = {
                'name': name,
                'post': [post]
            }
        
        else:
            if post not in self.user_dictionary[mail]['post']:
                self.user_dictionary[mail]['post'].append(post)
        
        self.save_file()
    
    def add_user_with_group(self, mail: str, name: str, type_of_user: str, group: str = None):
        if mail == None or name == None or type_of_user == None:
            raise TypeError('expected mail, name and mentor')
        
        if mail not in self.user_dictionary:
            self.user_dictionary[mail] = {
                'Name': name,
                'Type': type_of_user,
                'Group': [group]
                }

        else:
            self.user_dictionary[mail]['Group'].append(group)
            '''if self.user_dictionary[mail]['mentor_group'] == None:
                self.user_dictionary[mail]['mentor_group'] = mentor_group

            elif self.user_dictionary[mail]['mission_group'] == None:
                self.user_dictionary[mail]['mission_group'] = mission_group'''
            
        self.save_file()

    def get_value(self, dic, element: str):
        if type(dic) == str:
            if dic == element:
                return dic.get()
            else:
                return None
        
        for key in dic.keys():
            if key == element:
                 return dic.get(key)
            else:
                result = self.get_value(dic.get(key), element)
                if result != None:
                     return result
        return None
        
    def contains(self, dic, element: str):
        if type(dic) == str:
            if dic == element:
                return True
            else:
                return False
        
        for key in dic.keys():
            if key == element:
                    return True
            else:
                result = self.contains(dic.get(key), element)
                if result:
                    return result
        return False
    
    def load_file(self):
        with open(self.file_name, 'r', encoding='UTF-8-SIG') as f:
            return json.load(f)
        
    def save_file(self):
         with open(self.file_name, 'w', encoding='UTF-8-SIG') as f:
              json.dump(self.user_dictionary, f)

with open('user_data.csv', 'r', encoding='UTF-8-SIG') as f:
    mentor_group_list = f.readline()
    mission_group_list = f.readline()
    user_dic = {}

    for line in f.readlines():
        line = line[:-1].replace('\"', '')
        mail, name, group, mentor = line.split(',')
        
        if group not in mentor_group_list and group not in mission_group_list:
            continue
            
        if mentor == 'true': type_of_user = 'mentor'
        else: type_of_user = 'mentee'
        
        if mail not in user_dic.keys():
            user_dic[mail] = {
                    'Name': name,
                    'Type': type_of_user,
                    'Groups': [group]
                    }
        
        else:
            user_dic[mail]['Groups'].append(group)

with open('poster.csv', 'r', encoding='UTF-8-SIG') as f:
    post_dic ={}
    
    for line in f.readlines():
        line = line[:-1].replace('\"', '')
        name, mail, foodpref, post = line.split(',')
        mail = mail.strip()
        post = post.strip()

        if mail not in post_dic.keys():
            post_dic[mail] = {
                'Name': name,
                'Posts': [post]
            }
        else:
            post_dic[mail]['Posts'].append(post)

with open('user_dic.json', 'w', encoding='UTF-8-SIG') as f: json.dump(user_dic, f)
with open('post_dic.json', 'w', encoding='UTF-8-SIG') as f: json.dump(post_dic, f)