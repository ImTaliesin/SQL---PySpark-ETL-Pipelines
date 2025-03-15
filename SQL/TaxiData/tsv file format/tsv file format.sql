drop external file format tsv_file_format_pv1

create external file format tsv_file_format_pv1
with (
    format_type = DELIMITEDTEXT,
    format_options (
        field_terminator = '\t',
        string_delimiter = '"',
        first_row = 2,
        use_type_default = FALSE,
        Encoding = 'UTF8',
        parser_version = '1.0'
    )
)