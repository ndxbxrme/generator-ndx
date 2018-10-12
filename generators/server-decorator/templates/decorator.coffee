'use strict'

module.exports = (ndx) ->
  decorate = (args, cb) ->
    if args.obj and args.obj.deleted
      return cb true
    switch args.table
      when '<%= settings.userTable %>'<% var tables = settings.dbTables.split(/,/g); for(var f=0; f<tables.length; f++) { if(tables[f].trim()) {%>, '<%= tables[f].trim() %>'<% }} %>
        cb true
      else
        cb true
  ndx.decorator = {}
  setImmediate ->
    ndx.database.on 'preInsert', decorate
    ndx.database.on 'preUpdate', decorate