jQuery(document).ready(function() {
  $('.sortable_table').DataTable(
    {
      paging: false,
      "columns": [
        null,
        null,
        null,
        null,
        { "orderable": false },
        { "orderable": false },
        { "orderable": false },
      ]
    }
  );
} );
