[today, now] = CurrentDay()

# Config variables:
col = [
  {
    name: 'brand'
    description: 'Some Brand'
  }]

# Initialization
# http://docs.webix.com/api__refs__ui.datatable.html
dataTable =
  view: 'datatable'
  id: 'datatable'
  # scheme: $init: (obj) ->
  #   #obj - data object from incoming data
  #   obj.brand = obj.moreStuff.phone.brand
  columns: [ {
    id: col[0].name
    header: col[0].description
    editor: 'text'
    fillspace: true
    map: '#moreStuff.phone.brand#'
  } ]
  select: true
  editable: true
  editaction: 'dblclick'
  url: webix.proxy('meteor', Data)
  save: webix.proxy('meteor', Data)

toolbar =
  view: 'toolbar'
  elements: [
    {
      view: 'label'
      label: 'Double-click a row to edit. Click on columns to sort.'
    }
    {
      view: 'button'
      value: 'Add'
      width: 100
      click: ->
        row = $$('datatable').add({})
        $$('datatable').editCell row, 'title'
    }
    {
      view: 'button'
      value: 'Remove'
      width: 100
      click: ->
        id = $$('datatable').getSelectedId()
        if id
          $$('datatable').remove id
        else
          webix.message 'Please select a row to delete'
        return
    }
  ]

detailForm =
  view: 'form'
  id: 'detail-form'
  elements: [
    { view: 'text', name: col[0].name, label: col[0].description, labelWidth: 120 }
    {
      view: 'button'
      label: 'Save'
      type: 'form'
      click: ->
        @getFormView().save()
        @getFormView().clear()
    }
  ]

Template.ManageData.onCreated ->
  # Use this.subscribe inside onCreated callback
  @subscribe 'ManageData'

Template.ManageData.rendered = ->
  webixContainer = webix.ui(
    container: 'ManageData-Webix'
    view: 'layout'
    rows: [
      { cols: [
        {
          rows: [
            toolbar
            dataTable
          ]
        }
      ] }
      { view: 'resizer' }
      detailForm
    ]
  )

  # The problem with mixing Webix components and non-Webix HTML markup is that
  # Webix UI components won't resize automatically if you place them in an HTML
  # container. You have to resize them manually, like below:
  # Read more at http://forum.webix.com/discussion/comment/3650/#Comment_3650.
  webix.event window, 'resize', ->
    webixContainer.resize()

  # http://docs.webix.com/desktop__data_binding.html
  $$('detail-form').bind $$('datatable')