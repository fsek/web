import os
import string
import yaml

ignore_chars = [ 'a', 'e', 'o','u', 'i', 'å', 'ä', 'y', 'ö',

]

skip_chars = [
'\'', '\"', '{', '}', '%', '-', ':', '&', '<', '>', '$', ';'
]

def translate(line):
    skip_word = False
    new_string = ""
    for c in line:
        new_string += c
        if c in skip_chars:
            skip_word = True
        elif c in string.whitespace:
            skip_word = False

        if c not in string.whitespace and not c.lower() in ignore_chars and not c.isnumeric() and not skip_word:
            new_string += 'o' + c.lower()
    return new_string

def find_end(start, parent, k):
    if isinstance(start, dict):
        for o in start:
            find_end(start[o], start, o)
    elif isinstance(start, str):
        parent[k] = translate(start)
    elif isinstance(start, list):
        for e in range(len(start)):
            if isinstance(start[e], str):
                start[e] = translate(start[e])
    else:
        pass
        #print(type(start))


def translate_file(dir):
    print(dir)
    f = None
    with open(dir, "r+") as file:
        f = yaml.load(file)
        find_end(f, None, None)

    os.remove(dir)

    with open(dir, 'x') as file:
        yaml.dump(f, file)



for root, dirs, files in os.walk(os.getcwd()):
    for dir in files:
        if dir[len(dir) - 1] == 'l':
            translate_file(os.path.join(root, dir))