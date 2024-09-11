#!/bin/bash

# Default collection file
DEFAULT_COLLECTION="collections/restfull_booker_collection.json"

# Load the .env file
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

# Get build numbers from environment variables or default values
BUILD_NUMBER_CPW=${BUILD_NUMBER_CPW:-'default-cpw-build-number'}
BUILD_NUMBER_STS=${BUILD_NUMBER_STS:-'default-sts-build-number'}

# Check if environment argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 {prod|local|qa1|qa2|qa3|staging} [restfull_booker_collection|1_collection|2_collection]"
    exit 1
fi

# Set the environment file based on the first argument
ENV=$1

case $ENV in
    prod)
        ENV_FILE="environments/prod_environment.json"
        ;;
    local)
        ENV_FILE="environments/local_environment.json"
        ;;
    qa1)
        ENV_FILE="environments/qa1_environment.json"
        ;;
    qa2)
        ENV_FILE="environments/qa2_environment.json"
        ;;
    qa3)
        ENV_FILE="environments/qa3_environment.json"
        ;;
    staging)
        ENV_FILE="environments/staging_environment.json"
        ;;    
    *)
        echo "Invalid environment: $ENV"
        exit 1
        ;;
esac

# Check if a specific collection is provided as the second argument
if [ -n "$2" ]; then
    COLLECTION=$2
else
    COLLECTION="restfull_booker_collection"
fi

COLLECTION_FILE="collections/${COLLECTION}.json"


# Print paths for debugging
echo "Using environment file: $ENV_FILE"
echo "Using collection file: $COLLECTION_FILE"
echo "Using build number CPW: $BUILD_NUMBER_CPW"
echo "Using build number STS: $BUILD_NUMBER_STS"

# Ensure the reports directory exists
mkdir -p reports

# Ensure newman and the htmlextra reporter are installed
if ! npm list -g | grep newman &> /dev/null || ! npm list -g | grep newman-reporter-htmlextra &> /dev/null
then
    echo "Newman or the htmlextra reporter is not installed, installing them now..."
    npm install -g newman newman-reporter-htmlextra
fi

# Get the collection name without the file extension for the report name
COLLECTION_NAME=$(basename "$COLLECTION_FILE" .json)

# Generate a timestamp for the report name
DATE=$(date +"%Y%m%d_%H%M%S")


# Create a report file name with date and collection name
REPORT_FILE="reports/report_${ENV_FILE}_${COLLECTION_NAME}_${DATE}_${BUILD_NUMBER_STS}_${BUILD_NUMBER_CPW}.html"

# Run Newman with the selected environment and collection files
newman run "$COLLECTION_FILE" -e "$ENV_FILE" --reporters cli,htmlextra --reporter-htmlextra-export "$REPORT_FILE"

# Check if the HTML report was generated successfully
if [ ! -f "$REPORT_FILE" ]; then
    echo "HTML report not found: $REPORT_FILE"
    exit 1
fi

# Call the Node.js script to append build information to the report
node run_tests.js "$REPORT_FILE" "$BUILD_NUMBER_CPW" "$BUILD_NUMBER_STS"

# Exit with the same status as the newman run
EXIT_STATUS=$?
exit $EXIT_STATUS