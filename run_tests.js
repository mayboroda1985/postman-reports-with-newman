const fs = require('fs');
const path = require('path');

// Get the arguments passed to the script
const reportFile = process.argv[2];
const buildNumberRB = process.argv[3];
const buildNumberRB1 = process.argv[4];

// Check if the report file exists
if (!fs.existsSync(reportFile)) {
  console.error(`Report file not found: ${reportFile}`);
  process.exit(1);
}

// Read the HTML report
fs.readFile(reportFile, 'utf8', (err, data) => {
  if (err) {
    console.error(`Error reading report file: ${err}`);
    process.exit(1);
  }

  // Define the pattern where we want to insert the build numbers
  const pattern = /(<span><i class="fas fa-file-code"><\/i><\/span><strong> Environment:<\/strong> [^<]*<br>)/;

  // Insert the build numbers without additional line breaks between them
  const updatedData = data.replace(
    pattern,
    `$1<p><strong>RB Build Number:</strong> ${buildNumberRB}, <strong>RB1 Build Number:</strong> ${buildNumberRB1}</p>`
  );

  // Write the updated HTML back to the file
  fs.writeFile(reportFile, updatedData, 'utf8', (err) => {
    if (err) {
      console.error(`Error writing updated report: ${err}`);
      process.exit(1);
    }
    console.log(`Build numbers inserted successfully in ${reportFile}`);
  });
});