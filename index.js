const util = require('util');

// The Newman Reporter constructor function
function CustomReporter(newman, options) {
    newman.on('start', function (err, args) {
        console.log('Running a collection...');
    });

    newman.on('done', function (err, summary) {
        if (err) {
            console.error('Collection run encountered an error.');
        } else {
            console.log('Collection run completed.');
        }

        // Example of summary logging
        console.log(util.inspect(summary, { depth: null }));
    });
}

// Exports the reporter as a module
module.exports = CustomReporter;