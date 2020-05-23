from os import listdir, system
from os.path import isdir, isfile, join

"""
Encrypts all files inside the inventories directory.
Ansible must be installed and password.txt file must exist.

To edit encrypted file use: 
ansible-vault edit --vault-id password.txt <file>
"""


PATH = "inventories"
files_to_encrypt = []


def run():
    get_files(PATH)
    encrypt_files()


def get_files(path):
    for item in listdir(path):
        item_path = join(path, item)
        if isdir(item_path):
            get_files(item_path)

    files_to_encrypt.extend([
        join(path, _file) for _file
        in listdir(path)
        if isfile(join(path, _file))
    ])


def encrypt_files():
    for _file in files_to_encrypt:
        print(f"Encrypting {_file}")
        system(f"ansible-vault encrypt --vault-id password.txt {_file}")


run()
