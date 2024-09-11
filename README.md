# Postman Automated Tests with Reports using Newman

A project to automate Postman tests using Newman and Node.js.

## Installation

Clone the repository and install the dependencies:

```sh
git clone https://github.com/yourusername/postman-reports-with-newman.git
cd postman-automated-tests
npm install
npm install newman-reporter-htmlextra --save


## Directory Structure
Ensure your directory structure matches the following:
/project-root
|-- collections/
|   |-- restfull_booker_collection.json
|   |-- 1_collection.json
|   |-- 2_collection.json
|-- environments/
|   |-- local_environment.json
|   |-- prod_environment.json
|   |-- qa1_environment.json
|   |-- qa2_environment.json
|   |-- qa3_environment.json
|   |-- staging_environment.json
|-- reports/
|-- run_tests.sh


## Check Script Permissions
Ensure that the script has the correct permissions and is executable:
chmod +x run_tests.sh

## To run Reports with specific env and specific collection through bash , runs on background and not showing on terminal
./run_tests.sh staging restfull_booker_collection 


##  To run Reports with specific env and specific collection through bash , runs on background and not showing on terminal
newman run collections/restfull_booker_collection.json -e environments/prod_environment.json -r htmlextra --reporter-htmlextra-export "reports/report_restfull_booker_collection.html"

newman run collections/1_collection.json -e environments/qa1_environment.json -r htmlextra --reporter-htmlextra-export "reports/report_1_collection.html"

newman run collections/2_collection.json -e environments/qa2_environment.json -r htmlextra --reporter-htmlextra-export "reports/report_2_collection.html"

##Install .dotenv
npm install dotenv


##To run from JS file
 node run_tests.js collections/1_collection.json /environments/qa1_environment.json

## To run tests from package.json
change  line 7 to:

npm run test:prodAcceptance
npm run test:localCollectionPositive
npm run test:qa1CollectionNegative

# Run Newman with the selected environment and collection files in command line
newman run "$COLLECTION_FILE" -e "$ENV_FILE"--reporters cli,htmlextra --reporter-htmlextra-export "$REPORT_FILE"

# Run Newman with the selected environment and collection files without command line
newman run "$COLLECTION_FILE" -e "$ENV_FILE" -r htmlextra --reporter-htmlextra-export "$REPORT_FILE"

#When creating RC update package.json file line "coffeeshop_version": "version_number"
## New RC branch procedure:

#Create RC off the master
Publish
Create Pull Request
in VSC in package.json change build version (e.g. 34.1.0 >>>34.1.1)
Commit/Push to github
In github add description, PR plus build label and RC label
Create Draft PR

#When creating PR add the following info:
Pull Request
Release: <104.2.0>

Description
PVA v1.1

JIRA Link
e.g. https://coffeeshop.atlassian.net/browse/CP-3476

-- If it's a PR from RC to main branch, include link to CP release PR--

e.g. CoffeeShop/coffeshop#1684

Type of change
 Added/Changed automated scenarios
 Fix existing scenarios due to change in CP
 Improvement in the framework
 New feature in the framework

 # About run_tests.sh file

the #!/bin/bash file (run_tests.sh) is designed to run different collections such as collections/1_collection.json or collections/2_collection.json. Here's how it works:

How it handles different collections:
* The script expects the environment (like qa6, qa4, etc.) as the first argument.
* It expects the collection name (like restfull_booker_collection, 1_collection, or 2_collection) as the second argument.
* Key Lines in the Script:
# Check if a specific collection is provided as the second argument
if [ -n "$2" ]; then
    COLLECTION=$2
else
    COLLECTION="restfull_booker_collection"  # Default collection if none provided
fi

COLLECTION_FILE="collections/${COLLECTION}.json"

This logic works as follows:

* If you provide a second argument (for example, 2_collection), it will use collections/2_collection.json as the collection file.
* If no collection is specified, it will default to collections/restfull_booker_collection.json.

Example Usage:
To run the restfull_booker_negative_collection collection in the qa6 environment:
./run_tests.sh qa6 restfull_booker_negative_collection

This will:

Use the environments/qa6_environment.json file.
Use the collections/restfull_booker_negative_collection.json file.
To run the restfull_booker_negative_collection collection in the qa5 environment:
./run_tests.sh qa5 restfull_booker_negative_collection

This will:

Use the environments/qa5_environment.json file.
Use the collections/restfull_booker_negative_collection.json file.
Default Collection:
If no second argument (collection name) is provided, it will default to restfull_booker_collection.
./run_tests.sh qa6

This will:

Use environments/qa6_environment.json.
Use the default collections/restfull_booker_collection.json.
Conclusion:
The script is designed to be flexible and run different collections by simply passing the collection name as the second argument. If you don't specify one, it will fall back to the default collection (restfull_booker_collection.json).


Set Up GitHub Actions workflow:

Newman Runner
To see the runner working, we'll go back into our newly created GitHub repo this time in GitHub itself.

Select the root file path in master and click "Add file", "Create new file".

GitHub will only look for Actions which are stored under the following file path so make sure you enter the structure exactly.

Firstly, we type .github and then forward slash /.

After that, we type workflows/, then give our file a name ending in .yml, which is the correct format for an actions file.

