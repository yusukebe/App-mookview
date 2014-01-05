requires 'perl', '5.008001';

requires 'Plack';
requires 'Path::Tiny';
requires 'Text::Markdown::Hoedown';
requires 'Text::Xslate';
requires 'File::ShareDir';
requires 'Try::Tiny';
requires 'Number::Format';
requires 'HTML::Parser';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

