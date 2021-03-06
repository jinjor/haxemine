var system = require('system');
var page = require('webpage').create();

var getSources = function(){
    return ['out/js/sample.js'];
};
var getSpecs = function(){
    return ['test/spec/PathUtilTest.js'];
};

page.onConsoleMessage = function(msg) {
    console.log('phantom > ' + msg);
};
page.onError = function (msg, trace) {
    console.log(msg);
    trace.forEach(function(item) {
        console.log('  ', item.file, ':', item.line);
    })
}
page.open('local.html', function(){
  
  page.injectJs('jasmine-1.3.1/jasmine.js');
  //page.injectJs('jasmine-1.3.1/jasmine-html.js');
  //console.log(page.offlineStoragePath);
  getSources().concat(getSpecs()).forEach(function(path){
    page.injectJs(path);
  });
  page.evaluate(function() {
    if (! jasmine) {
        throw new Exception("jasmine library does not exist in global namespace!");
    }
    var ConsoleReporter = function() {
        this.started = false;
        this.finished = false;
    };
    ConsoleReporter.prototype = {
        reportRunnerResults: function(runner) {
            var dur = (new Date()).getTime() - this.start_time;
            var failed = this.executed_specs - this.passed_specs;
            var spec_str = this.executed_specs + (this.executed_specs === 1 ? " spec, " : " specs, ");
            var fail_str = failed + (failed === 1 ? " failure in " : " failures in ");

            this.log("Runner Finished.");
            this.log(spec_str + fail_str + (dur/1000) + "s.");
                
            this.finished = true;
        },

        reportRunnerStarting: function(runner) {
            this.started = true;
            this.start_time = (new Date()).getTime();
            this.executed_specs = 0;
            this.passed_specs = 0;
            this.log("Runner Started.");
        },

        reportSpecResults: function(spec) {
            var resultText = "Failed.";
            if (spec.results().passed()) {
                this.passed_specs++;
                resultText = "Passed.";
            }

            this.log(resultText);
        },

        reportSpecStarting: function(spec) {
            this.executed_specs++;
            this.log(spec);
            this.log(spec.suite);
            this.log(spec.suite.description + ' : ' + spec.description + ' ... ');
        },

        reportSuiteResults: function(suite) {
            var results = suite.results();
            this.log(suite.description + ": " + results.passedCount + " of " + results.totalCount + " passed.");
        },

        log: function(str) {
            //var console = jasmine.getGlobal().console;
            console.log('jasmine > ' + str);
        }
    };
    
    var jasmineEnv = jasmine.getEnv();
    jasmineEnv.updateInterval = 1000;
    jasmineEnv.addReporter(new ConsoleReporter());
    jasmineEnv.execute();
  });
  
  
});


