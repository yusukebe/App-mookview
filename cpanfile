requires 'perl', '5.008001';

requires 'Plack';
requires 'Path::Tiny';
requires 'Text::Markdown';
requires 'Text::Xslate';
requires 'File::ShareDir';
requires 'Try::Tiny';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

