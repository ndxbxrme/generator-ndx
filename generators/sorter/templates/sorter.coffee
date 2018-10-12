'use strict'

angular.module 'ndx'
.factory 'Sorter', ->
  create: (opts) ->
    set: (field) ->
      if opts.sort isnt field
        opts.sort = field
        opts.sortDir = 'ASC'
      else
        if opts.sortDir is 'DESC'
          opts.sortDir = 'ASC'
        else
          opts.sortDir = 'DESC'
    setLocal: (field) ->
      if not opts.sort
        opts.sort = ''
      if opts.sort.indexOf(field) is -1
        opts.sort = field
        opts.sortDir = 'ASC'
      else
        if opts.sort.indexOf('-') is 0
          opts.sort = field
          opts.sortDir = 'ASC'
        else
          opts.sort = "-#{field}"
          opts.sortDir = 'DESC'
    class: (field) ->
      "has-sort": true
      sorting: -1 < opts.sort.indexOf(field) < 2
      desc: opts.sortDir is 'DESC'