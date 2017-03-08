'use strict'

require 'ndx-server'
.config
  database: 'db'
  tables: ['users']
  localStorage: './data'
.use 'ndx-passport'
.use 'ndx-static-routes'
.start()
