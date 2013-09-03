#!/bin/bash
#script configuration
host=http://127.0.0.1
username=abc
password=xyz
afterLoginPage=$host/start_page
grepString=logged
cookiesFilename=cookies
csrfVarName=login[_csrf_token]
loginVarName=login[username]
passwordVarName=login[password]

#save cookies
curl -s -c $cookiesFileName $host > /dev/null 2>&1
#get csrf - maybe try something smarter than cut?
csrf=$(curl -s -b $cookiesFilename $host | grep 'token]".*value=".*"' -o | cut -f3 -d"\"")
#prepare POST data
data=$(echo "$csrfVarName=$csrf&$loginVarName=$username&$passwordVarName=$password")
#login
curl -s -b $cookiesFilename -c $cookiesFilename -d $data -X POST $host > /dev/null 2>&1
#get page after login and check for info about being logged in
afterLogin=$(curl -s -b $cookiesFilename $afterLoginPage | grep $grepString)
if [[ "$afterLogin" == *$username* ]] 
then
  echo 'OK'
else
  echo 'FAIL'
fi
