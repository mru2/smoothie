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
        build:  '.build',   // The folder for the minified/files, before upload


        // Watchers
        watch: {
            // Compile coffeescript files
            coffee: {
                files: ['<%= src %>/scripts/**/*.coffee'],
                tasks: ['coffee:dist']
            },

            // Compile sass files
            sass: {
                files: ['<%= src %>/styles/**/*.{scss,sass}'],
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
            prodConfig: {
                files: {
                    '<%= dist %>/scripts/config.js': '<%= dist %>/scripts/config-prod.js'
                }
            },

            // Use the development configuration
            devConfig: {
                files: {
                    '<%= dist %>/scripts/config.js': '<%= dist %>/scripts/config-dev.js'
                }
            },

            // Copy the production assets for packaging (the ones who won't need processing)
            build: {
                files: [

                    // Misc files
                    {
                        expand: true,
                        dot: true,
                        cwd: '<%= dist %>',
                        dest: '<%= build %>',
                        src: [
                            '*.{ico,txt}',
                            '.htaccess',
                            'images/{,*/}*.{webp,gif}', // Other images are minified
                            'crossdomain.xml',
                            'font/*',
                            'templates/*',
                            '*.html'
                        ]
                    },

                    // RequireJS
                    { '<%= build %>/components/requirejs/require.js': '<%= dist %>/components/requirejs/require.js' }
                ]
            }
        },


        // Upload the assets to s3
        s3: {
            options: {
              key: 'AKIAIR4AYE2CPFW4QVYQ',
              secret: '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',
              bucket: 'smoothie.fm',
              access: 'public-read',
              region: 'eu-west-1'
            },
            build: {
              // // These options override the defaults
              // options: {
              //   encodePaths: true,
              //   maxOperations: 20
              // },
              // Files to be uploaded.
              upload: [
                {
                  src: '<%= build %>/*',
                  dest: '/'
                },
                {
                  src: '<%= build %>/styles/*',
                  dest: 'styles/'
                },
                {
                  src: '<%= build %>/scripts/*',
                  dest: 'scripts/'
                },
                {
                  src: '<%= build %>/images/*',
                  dest: 'images/'
                },
                {
                  src: '<%= build %>/font/*',
                  dest: 'font/'
                },
                {
                  src: '<%= build %>/templates/*',
                  dest: 'templates/'
                },
                {
                  src: '<%= build %>/components/requirejs/require.js',
                  dest: 'components/requirejs/require.js'
                }
              ]
            }

        },


        // === Building for production === //

        // Compile the frontend app
        requirejs: {
            compile: {
                options: {
                    useStrict: true,
                    wrap: true,
                    baseUrl: '<%= dist %>/scripts',
                    name: 'app',
                    mainConfigFile: '<%= dist %>/scripts/app.js',
                    out: '<%= build %>/scripts/app.js'
                }
            }
        },

        // Image minification
        imagemin: {
            build: {
                files: [{
                    expand: true,
                    cwd: '<%= dist %>/images',
                    src: '{,*/}*.{png,jpg,jpeg}',
                    dest: '<%= build %>/images'
                }]
            }
        },
        svgmin: {
            build: {
                files: [{
                    expand: true,
                    cwd: '<%= dist %>/images',
                    src: '{,*/}*.svg',
                    dest: '<%= build %>/images'
                }]
            }
        },

        // CSS minification
        cssmin: {
            build: {
                expand: true,
                cwd: '<%= dist %>/styles',
                src: '{,*/}*.css',
                dest: '<%= build %>/styles'
            }
        },


        // === Concurrent tasks === //

        concurrent: {
            // Assets compiling and copying 
            dist: [
                'coffee:dist',
                'compass:dist',
                'copy:dist'
            ],

            // Assets minification and packaging
            build: [
                'copy:build',
                'imagemin:build',
                'svgmin:build',
                'cssmin:build'
            ],
        }

    });


    grunt.renameTask('regarde', 'watch');


    grunt.registerTask('server',[
        'clean:dist',
        'concurrent:dist',
        'copy:devConfig',
        'watch'
    ]);


    grunt.registerTask('build',[
        // Prepare the build in public
        'clean:dist',
        'concurrent:dist',
        'copy:prodConfig',

        // Compile and move the assets to the build folder
        'clean:build',
        'requirejs:compile',
        'concurrent:build',
        's3:build'
    ]);
};
