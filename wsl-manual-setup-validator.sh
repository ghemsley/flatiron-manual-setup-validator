#!/bin/sh


# https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
NC='\033[0m' # No Color
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'


# https://stackoverflow.com/questions/6212219/passing-parameters-to-a-bash-function
# https://stackoverflow.com/questions/5615717/how-to-store-a-command-in-a-variable-in-linux
# https://stackoverflow.com/questions/17336915/return-value-in-a-bash-function
# $1 => Command to run
evaluate_test () {
  # https://stackoverflow.com/questions/11193466/echo-without-newline-in-a-shell-script
  eval $1 && printf "${GREEN}pass${NC}\n" || printf "${RED}fail${NC}\n"
}

evaluate () {
  eval $1
}

# $1 => Test Name
# $2 => Command to run
print_table_results () {
  local result=$(evaluate_test "$2")
  # https://stackoverflow.com/questions/6345429/how-do-i-print-some-text-in-bash-and-pad-it-with-spaces-to-a-certain-width
  printf "%-30s => [ %-6s ]\n" "$1" "$result"
}

# $1 => Test Name
# $2 => Command to run
print_data_row () {
  local result=$(evaluate "$2")
  # https://stackoverflow.com/questions/6345429/how-do-i-print-some-text-in-bash-and-pad-it-with-spaces-to-a-certain-width
  printf "%-12s => [ %-6s ]\n" "$1" "$result"
}

delimiter () {
  printf "${BLUE}******************************************${NC}\n"
}

validation_header () {
  printf "\n${CYAN}************ VALIDATING SETUP ************${NC}\n\n"
}

configuration_header () {
  printf "\n${CYAN}************* CONFIGURATION **************${NC}\n\n"
}


## Validation
validation_header
delimiter

## 1. Uninstall Learn IDE
## TODO

## 7. Ruby Version Manager (rvm)
print_table_results "Installed RVM" "command -v rvm >/dev/null 2>&1 && which rvm | grep -q '/.rvm/bin/rvm'"
print_table_results "Default RVM (2.6.1)" "command -v rvm >/dev/null 2>&1 && rvm list | grep -Fq '=* ruby-2.6.1 [ x86_64 ]'"
print_table_results "Test RVM PATH" "command -v rvm >/dev/null 2>&1 && rvm list | grep -Fqv 'Warning! PATH'"
delimiter

## 8. Gems
print_table_results "Gem: learn-co" "command -v gem >/dev/null 2>&1 && gem list | grep -q 'learn-co '"
print_table_results "Gem: bundler" "command -v gem >/dev/null 2>&1 && gem list | grep -q 'bundler'"
delimiter


## 9. Learn
## See Student Configuration section.

## 10. Text Editor: VS Code
print_table_results "Installed VSCode" "command -v code >/dev/null 2>&1 && code -v | grep -q '1.'"
print_table_results "VSCode set as Learn Editor" "cat ~/.learn-config | grep ':editor:' | grep -q 'code'"
delimiter

## 12. Databases
print_table_results "Installed sqlite" "command -v sqlite3 >/dev/null 2>&1"
delimiter

## 13. Rails
print_table_results "Installed Rails" "command -v rails >/dev/null 2>&1 && rails --version | grep -q 'Rails'"
print_table_results "Gem: rails" "command -v gem >/dev/null 2>&1 && gem list | grep -q 'rails'"
delimiter

## 14. Node Version Manager (nvm)
# https://unix.stackexchange.com/questions/184508/nvm-command-not-available-in-bash-script
# https://stackoverflow.com/questions/39190575/bash-script-for-changing-nvm-node-version
. ~/.nvm/nvm.sh
print_table_results "Installed NVM" "command -v nvm >/dev/null 2>&1 && nvm --version | grep -q '[0-9]*\.[0-9]*\.[0-9]*'"
print_table_results "Installed Node" "command -v node | grep -q '.nvm/versions/node'"
print_table_results "Default Node (>11.x)" 'command -v nvm >/dev/null 2>&1 && nvm version default | grep -q "v11\|v12\|v13\|v14\|v15\|v16\|v17\|v18\|v19\|v20"'
# print_table_results "Default Node (10.x)" 'command -v nvm >/dev/null 2>&1 && nvm version default | grep -q "v10"'
# print_table_results "Default Node (6.11.2)" 'command -v nvm >/dev/null 2>&1 && nvm version default | grep -q "v6.11.2"'
delimiter

## 15. Google Chrome
# https://unix.stackexchange.com/questions/63387/single-command-to-check-if-file-exists-and-print-custom-message-to-stdout
print_table_results "Installed Google Chrome" "[ -f /mnt/c/'Program Files'/Google/Chrome/Application/chrome.exe ]"
delimiter

## 5. git
# https://stackoverflow.com/questions/12254076/how-do-i-show-my-global-git-config
print_table_results "Installed git" "command -v git >/dev/null 2>&1 && git version | grep -q 'git version'"
print_table_results "Github user config" "command -v git >/dev/null 2>&1 && git config --list | grep -q 'user.name='"
print_table_results "Github email config" "command -v git >/dev/null 2>&1 && git config --list | grep -q 'user.email='"
delimiter

## Student Configuration
configuration_header
delimiter

## 5. git
echo "Github"
print_data_row "Username" "command -v git >/dev/null 2>&1 && git config user.name"
print_data_row "Email" "command -v git >/dev/null 2>&1 && git config user.email"
delimiter

## 9. Learn
# https://stackoverflow.com/questions/369758/how-to-trim-whitespace-from-a-bash-variable
echo "Learn"
print_data_row "Name" "command -v learn >/dev/null 2>&1 && learn whoami | grep 'Name:' | sed 's/Name://g' | sed -e 's/^[[:space:]]*//'"
print_data_row "Username" "command -v learn >/dev/null 2>&1 && learn whoami | grep 'Username:' | sed 's/Username://g' | sed -e 's/^[[:space:]]*//'"
print_data_row "Email" "command -v learn >/dev/null 2>&1 && learn whoami | grep 'Email:' | sed 's/Email://g' | sed -e 's/^[[:space:]]*//'"
delimiter
