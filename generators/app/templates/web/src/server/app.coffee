'use strict'

require 'ndx-server'
.config
  database: 'db'
  tables: ['users']
  localStorage: './data'
.use 'ndx-static-routes'
.start()
