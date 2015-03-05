# dependencies
fs = require 'fs'
path = require 'path'
gulp = require 'gulp'
git = require 'gulp-git'
bump = require 'gulp-bump'
filter = require 'gulp-filter'
tag_version = require 'gulp-tag-version'
del = require 'del'
concat = require 'gulp-concat-util'
order = require 'gulp-order'
rename = require 'gulp-rename'
runSequence = require 'run-sequence'
changelog = require 'conventional-changelog'

coffee = require 'gulp-coffee'
coffeelint = require 'gulp-coffeelint'

gulp.task 'clean:dist', (cb) -> del ['dist/*'], cb
gulp.task 'compile:coffee', ->
	pkg = JSON.parse fs.readFileSync './package.json', 'utf8'
	gulp.src ['./src/main.coffee']
		# Lint the coffescript
		.pipe coffeelint()
		.pipe coffeelint.reporter()
		.pipe coffeelint.reporter 'fail'
		.pipe coffee bare: true
		.pipe rename 'sc-validation.js'
		.pipe concat()
		.pipe concat.header """/*
			@license sc-validation
			@author SimeonC
			@license 2015 MIT
			@version #{pkg.version}
			
			See README.md for requirements and use.
		*/
		"""
		.pipe gulp.dest 'dist'

gulp.task 'compile', ['compile:coffee']

###
	Bumping version number and tagging the repository with it.
	
	You can use the commands
		
		gulp prerel		# makes v0.1.0 -> v0.1.1-pre1
		gulp patch		# makes v0.1.0 → v0.1.1
		gulp minor		# makes v0.1.1 → v0.2.0
		gulp major		# makes v0.2.1 → v1.0.0
	
	To bump the version numbers accordingly after you did a patch,
	introduced a feature or made a backwards-incompatible release.
###
releaseVersion = (importance) ->
	# get all the files to bump version in
	gulp.src ['./package.json', './bower.json']
		# bump the version number in those files
		.pipe bump type: importance
		# save it back to filesystem
		.pipe gulp.dest './'
gulp.task 'tagversion', ->
	gulp.src ['./package.json','./bower.json','./changelog.md','./dist/*']
		# commit the changed version number
		.pipe git.commit 'chore(release): Bump Version Number'
		# Filter down to only one file
		.pipe filter 'package.json'
		# **tag it in the repository**
		.pipe tag_version()

gulp.task 'changelog', (cb) ->
	pkg = JSON.parse fs.readFileSync './package.json', 'utf8'
	changelog
		version: pkg.version
		repository: pkg.repository.url
	, (err, content) ->
		fs.writeFile './changelog.md', content, cb

gulp.task 'release:prerel', -> releaseVersion 'prerelease'
gulp.task 'release:patch', -> releaseVersion 'patch'
gulp.task 'release:minor', -> releaseVersion 'minor'
gulp.task 'release:major', -> releaseVersion 'major'
gulp.task 'prerel', ->
	runSequence(
		'release:prerel'
		, 'changelog'
		, 'compile'
		, 'tagversion'
	)
gulp.task 'patch', -> 
	runSequence(
		'release:patch'
		, 'changelog'
		, 'compile'
		, 'tagversion'
	)
gulp.task 'minor', ->
	runSequence(
		'release:minor'
		, 'changelog'
		, 'compile'
		, 'tagversion'
	)
gulp.task 'major', ->
	runSequence(
		'release:major'
		, 'changelog'
		, 'compile'
		, 'tagversion'
	)

gulp.task 'default', ['compile']