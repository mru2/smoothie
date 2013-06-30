'use strict';

// Usage
// grunt server : compile to /public and watches changes on coffee / sass files
// grunt build  : build to /.tmp, minified and revisioned, and pushes it to s3


module.exports = function (grunt) {

    // load all grunt tasks
    require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks);

    grunt.initConfig({

        // Variables
        src:    'app',    // The application folder
        dist:   'public', // The compiled folder
        build:  '.tmp',   // The folder for the minified/files, before upload


        // Watchers
        watch: {
            // Compile coffeescript files
            coffee: {
                files: ['<%= src %>/scripts/{,*/}*.coffee'],
                tasks: ['coffee:dist']
            },

            // Compile sass files
            sass: {
                files: ['<%= src %>/styles/{,*/}*.{scss,sass}'],
                tasks: ['compass:dist']
            }
        },


        // Clean the dist and build directories
        clean: {
            dist: {
                files: [{
                    dot: true,
                    src: [
                        '<%= dist %>/*'
                    ]
                }]
            },
            build: {
                files: [{
                    dot: true,
                    src: [
                        '<%= build %>/*'
                    ]
                }]
            }
        },


        // Coffeescript compilation
        coffee: {
            dist: {
                expand: true,
                cwd: '<%= src %>/scripts/',
                src: '**/*.coffee',
                dest: '<%= dist %>/scripts',
                ext: '.js'
            }
        },


        // SASS compilation
        compass: {
            options: {
                sassDir: '<%= src %>/styles',
                cssDir: '<%= dist %>/styles',
                imagesDir: '<%= src %>/images',
                javascriptsDir: '<%= src %>/scripts',
                fontsDir: '<%= src %>/font',
                importPath: '<%= src %>/components',
                relativeAssets: true
            },
            dist: {}
        },


        // Simultaneous asset building and copying, to save time 
        concurrent: {
            build: [
                'coffee:dist',
                'compass:dist',
                'copy:dist'
            ]
        },


        // Copying other assets not handled elsewhere
        copy: {

            // All the base assets
            dist: {
                files: [

                    // Misc files
                    {
                        expand: true,
                        dot: true,
                        cwd: '<%= src %>',
                        dest: '<%= dist %>',
                        src: [
                            '*.{ico,txt}',
                            '.htaccess',
                            'images/*',
                            'crossdomain.xml',
                            'font/*',
                            'templates/*',
                            '*.html'
                        ]
                    },

                    // Javascript files
                    {
                        expand: true,
                        dot: true,
                        cwd: '<%= src %>/scripts',
                        dest: '<%= dist %>/scripts',
                        src: [
                            '{,*/}*.js',
                        ]
                    },

                    // Javascript libraries
                    {
                        expand: true,
                        dot: true,
                        cwd: '<%= src %>/components',
                        dest: '<%= dist %>/components',
                        src: [
                            '{,*/}*.js',
                        ]
                    }
                ]
            },

            // Use the production configuration
            prod: {
                files: [{
                    src: '<%= src %>/scripts/config.prod.js',
                    dest: '<%= dist %>/scripts/config.js'
                }]
            },

            // Use the development configuration
            dev: {
                files: [{
                    src: '<%= src %>/scripts/config.dev.js',
                    dest: '<%= dist %>/scripts/config.js'
                }]
            }
        },


        // // Requirejs building
        // requirejs: {
        //     dist: {
        //         // Options: https://github.com/jrburke/r.js/blob/master/build/example.build.js
        //         options: {
        //             // `name` and `out` is set by grunt-usemin
        //             // baseUrl: 'app/scripts',
        //             // baseUrl: '.tmp/scripts', // Use .tmp to handle coffeescript files. cf. https://github.com/yeoman/yeoman/issues/956
        //             optimize: 'none',
        //             // TODO: Figure out how to make sourcemaps work with grunt-usemin
        //             // https://github.com/yeoman/grunt-usemin/issues/30
        //             //generateSourceMaps: true,
        //             // required to support SourceMaps
        //             // http://requirejs.org/docs/errors.html#sourcemapcomments
        //             preserveLicenseComments: false,
        //             useStrict: true,
        //             wrap: true,
        //             // name: 'radio',
        //             // out: 'public/scripts/radio.js',
        //             // mainConfigFile: 'app/scripts/radio.js'
        //             //uglify2: {} // https://github.com/mishoo/UglifyJS2
        //         }
        //     }
        // },


        // // 
        // jshint: {
        //     options: {
        //         jshintrc: '.jshintrc'
        //     },
        //     all: [
        //         'Gruntfile.js',
        //         '<%= yeoman.app %>/scripts/{,*/}*.js',
        //         '!<%= yeoman.app %>/scripts/vendor/*',
        //         'test/spec/{,*/}*.js'
        //     ]
        // },



        // // Assets revisioning
        // rev: {
        //     dist: {
        //         files: {
        //             src: [
        //                 '<%= yeoman.dist %>/scripts/{,*/}*.js',
        //                 '<%= yeoman.dist %>/styles/{,*/}*.css',
        //                 '<%= yeoman.dist %>/images/{,*/}*.{png,jpg,jpeg,gif,webp}',
        //                 '<%= yeoman.dist %>/font/*'
        //             ]
        //         }
        //     }
        // },


        // useminPrepare: {
        //     html: '<%= yeoman.app %>/index.html',
        //     options: {
        //         dest: '<%= yeoman.dist %>'
        //     }
        // },
        // usemin: {
        //     html: ['<%= yeoman.dist %>/{,*/}*.html'],
        //     css: ['<%= yeoman.dist %>/styles/{,*/}*.css'],
        //     options: {
        //         dirs: ['<%= yeoman.dist %>']
        //     }
        // },
        // imagemin: {
        //     dist: {
        //         files: [{
        //             expand: true,
        //             cwd: '<%= yeoman.app %>/images',
        //             src: '{,*/}*.{png,jpg,jpeg}',
        //             dest: '<%= yeoman.dist %>/images'
        //         }]
        //     }
        // },
        // svgmin: {
        //     dist: {
        //         files: [{
        //             expand: true,
        //             cwd: '<%= yeoman.app %>/images',
        //             src: '{,*/}*.svg',
        //             dest: '<%= yeoman.dist %>/images'
        //         }]
        //     }
        // },
        // cssmin: {
        //     dist: {
        //         files: {
        //             '<%= yeoman.dist %>/styles/main.css': [
        //                 '.tmp/styles/{,*/}*.css',
        //                 '<%= yeoman.app %>/styles/{,*/}*.css'
        //             ]
        //         }
        //     }
        // },
        // htmlmin: {
        //     dist: {
        //         options: {
        //             /*removeCommentsFromCDATA: true,
        //             // https://github.com/yeoman/grunt-usemin/issues/44
        //             //collapseWhitespace: true,
        //             collapseBooleanAttributes: true,
        //             removeAttributeQuotes: true,
        //             removeRedundantAttributes: true,
        //             useShortDoctype: true,
        //             removeEmptyAttributes: true,
        //             removeOptionalTags: true*/
        //         },
        //         files: [{
        //             expand: true,
        //             cwd: '<%= yeoman.app %>',
        //             src: '*.html',
        //             dest: '<%= yeoman.dist %>'
        //         }]
        //     }
        // },


        // // Put files not handled in other tasks here
        // copy: {

        //     // Copying js files to dist for requirejs:dist handling. c.f https://github.com/yeoman/yeoman/issues/956
        //     js: {
        //         files: [{
        //             expand: true,
        //             dot: true,
        //             cwd: '<%= yeoman.app %>/scripts',
        //             dest: '.tmp/scripts',
        //             src: [
        //                 '{,*/}*.js',
        //             ]
        //         },{
        //             expand: true,
        //             dot: true,
        //             cwd: '<%= yeoman.app %>/components',
        //             dest: '.tmp/components',
        //             src: [
        //                 '{,*/}*.js',
        //             ]
        //         },{
        //             src: '<%= yeoman.app %>/scripts/config.prod.js',
        //             dest: 'public/scripts/config.js'
        //         }]
        //     },

        //     // Copy tree to .tmp for the server
        //     server: {
        //         files: [
        //             {
        //                 expand: true,
        //                 cwd: '<%= yeoman.app %>',
        //                 src: '**',
        //                 dest: '.tmp',
        //             },
        //             {
        //                 src: '<%= yeoman.app %>/scripts/config.dev.js',
        //                 dest: '.tmp/scripts/config.js'
        //             }
        //         ]
        //     },

        //     dist: {
        //         files: [{
        //             expand: true,
        //             dot: true,
        //             cwd: '<%= yeoman.app %>',
        //             dest: '<%= yeoman.dist %>',
        //             src: [
        //                 '*.{ico,txt}',
        //                 '.htaccess',
        //                 'images/{,*/}*.{webp,gif}',
        //                 'crossdomain.xml',
        //                 'font/*',
        //                 'templates/*'
        //             ]
        //         }]
        //     },
        // },
        // concurrent: {            
        //     server: [
        //         'coffee:dist',
        //         'compass:server',
        //         'copy:server'
        //     ],
        //     dist: [
        //         'coffee',
        //         'compass:dist',
        //         'imagemin',
        //         'svgmin',
        //         'htmlmin'
        //     ]
        // },
        bower: {
            options: {
                exclude: ['modernizr']
            },
            all: {
                rjsConfig: '<%= yeoman.app %>/scripts/main.js'
            }
        }
    });

    grunt.renameTask('regarde', 'watch');

    // grunt.registerTask('server', function (target) {
    //     if (target === 'dist') {
    //         return grunt.task.run(['build', 'open', 'connect:dist:keepalive']);
    //     }

    //     grunt.task.run([
    //         'clean:server',
    //         'concurrent:server',
    //         'livereload-start',
    //         'connect:livereload',
    //         'open',
    //         'watch'
    //     ]);
    // });

    // grunt.registerTask('test', [
    //     'clean:server',
    //     'concurrent:test',
    //     'connect:test',
    //     'mocha'
    // ]);

    // grunt.registerTask('build', [
    //     // 'clean:dist', // Commented because of conflicts on deployment with shared files 
    //     'useminPrepare',
    //     'concurrent:dist',
    //     'copy:js',
    //     'requirejs',
    //     'cssmin',
    //     'concat',
    //     'uglify',
    //     'copy',
    //     // revision commented out to be used in sinatra-rendered views
    //     // 'rev',
    //     'usemin'
    // ]);

    // grunt.registerTask('default', [
    //     'jshint',
    //     'test',
    //     'build'
    // ]);

    grunt.registerTask('server',[
        'clean:dist',
        'concurrent:build',
        'copy:dev',
        'watch'
    ]);

    grunt.registerTask('build',[

    ]);
};
