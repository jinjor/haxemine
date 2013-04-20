package org.jinjor.haxemine.server;

import js.Node;
import haxe.Json;

using org.jinjor.util.Util;
using Lambda;
using StringTools;

class HaxemineConfigDao {
    
    
    static inline var CONF_FILE = 'haxemine.json';
    static var path = Node.require('path');
    static var fs : Dynamic = Node.require('fs');
    static var readline = Node.require('readline');
    
    private static function makeConfpath(projectRoot : String){
        return projectRoot + '/' + CONF_FILE;
    }

    public function new() { 
    }
    
    public function get(projectRoot : String) : HaxemineConfig {
        var confPath = makeConfpath(projectRoot);
        if(!path.existsSync(confPath)){
            return null;
        }
        var conf : HaxemineConfig = Json.parse(fs.readFileSync(confPath, 'utf8'));
        conf.port = conf.port.or(8765);
        
        for(hxml in conf.hxml){
            hxml.auto = hxml.auto.or(true);
        }
        return conf;
    }
    
    public function create(process : Dynamic, projectRoot : String, onCreate : Void -> Void, onCancel : Void -> Void){
        var confPath = makeConfpath(projectRoot);
        
        Console.print(CONF_FILE + 'is required in current directory.');
        Console.print('create ' + CONF_FILE + ' here? [y/n]');
        
        var rli = readline.createInterface(process.stdin, process.stdout);

        rli.on('line', function(cmd) {
            if(cmd == 'y'){
                getAllHxmlFiles(projectRoot, function(err, files : Array<String>){
                    if(err != null){
                        Console.print(err);
                        throw(err);
                    }
                    files.sort(function(f1 : String, f2 : String){
                        return if(f1.startsWith('build') && f2.startsWith('compile')){
                            1;
                        }else{
                            -1;
                        }
                    });
                    var xhml = files.map(function(file){
                        return {path: file, auto: true};
                    }).array();
                    var conf = new HaxemineConfig(8765, xhml);
                    var confJson = untyped JSON.stringify(conf, null, " ");
                    fs.writeFileSync(confPath, confJson, "utf8");
                    Console.print('created haxemine.conf\n' + confJson);
                    Console.print('modify haxemine.conf and restart haxemine.');
                    onCreate();
                    untyped process.exit(0);
                });
            }else if(cmd == 'n'){
                process.stdin.destroy();
                onCancel();
            }
            rli.prompt();
        });
    }
        
    private static function getAllHxmlFiles(projectRoot : String, _callback){
        var filter = function(item : String){
            return item.endsWith('.hxml');
        };
        FileUtil.getAllMatchedFiles(projectRoot, filter, _callback);
    }


}