package App::mookview;
use 5.008005;
use strict;
use warnings;
use Plack::Request;
use Path::Tiny qw/path/;
use Text::Markdown::Hoedown qw/markdown/;
use Text::Xslate qw/mark_raw/;
use Number::Format qw/format_number/;
use File::ShareDir qw/dist_dir/;
use HTML::TokeParser;
use HTML::Entities qw/encode_entities/;
use Plack::App::Directory;
use Try::Tiny;
use Encode;

our $VERSION = "0.01";

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    my $name = shift or die "Markdown file path is required";
    my $file_path = path($name);
    die "Path: $file_path is not a file or does not exist" if !$file_path;
    $self->{file_path} = $file_path;
    $self->{xslate} = Text::Xslate->new(
        path => $self->local_or_share_path( [qw/share templates/] )
    );
    return $self;
}

sub local_or_share_path {
    my ($self, $p) = @_;
    my $path = path(@$p);
    return $path if $path->exists;
    try {
        shift @$p;
        $path = path(dist_dir('App-mookview'), @$p);
    };
    return $path;
}

sub psgi_app {
    my $self = shift;
    return sub {
        my $req  = Plack::Request->new(shift);
        my $path = $req->path_info;
        return $self->return_markdown($path) if $path eq '/';
        return $self->return_css($path) if $path =~ m!^/css/.+!;
        Plack::App::Directory->new->to_app->($req->env);        
    };
}

sub return_404 {
    return [404, [ 'Content-Type' => 'text/plain' ], ['Not Found'] ];
}

sub return_css {
    my ($self, $path) = @_;
    return $self->return_404 unless $path;
    my ($name) = $path =~ m!/([^/]+?)$!;
    my $local_path = $self->local_or_share_path([qw/share static css/, $name]);
    return $self->return_404 unless $local_path;
    my $css = $local_path->slurp();
    return [200, [ 'Content-Type' => 'text/css', 'Content-Length' => length $css ], [ encode_utf8($css) ] ];
}

sub return_markdown {
    my ($self, $path) = @_;
    my $text = $self->{file_path}->slurp_utf8();
    my $stock = '';   my $page = 1;  my $content = '';
    my $limit = 1100;
    for my $t (split /\n/, $text) {
        $stock .= $t . "\n";
        if (length $stock > $limit) {
            $content = $self->add_markdown_to_html($content, $stock, $page);
            $stock = '';
            $page++;
        }
    }
    $content = $self->add_markdown_to_html($content, $stock, $page);
    my $length = format_number(length $text);
    my $html = $self->{xslate}->render('preview.tx', { content => mark_raw($content), length => $length });
    return [200, [ 'Content-Type' => 'text/html', 'Content-Length' => length $html ], [ encode_utf8($html) ] ];
}

sub add_markdown_to_html {
    my ($self, $html, $markdown, $page) = @_;
    $html .= '<div class="page">' . markdown($markdown) . "</div>\n";
    $html .= '<div class="clear"></div>' . "\n";
    $html .= "<div class=\"page-number\">$page</div>\n";
    return $html;
}

1;

__END__

=encoding utf-8

=head1 NAME

App::mookview - It's new $module

=head1 SYNOPSIS

    use App::mookview;

=head1 DESCRIPTION

App::mookview is ...

=head1 LICENSE

Copyright (C) Yusuke Wada.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Yusuke Wada E<lt>yusuke@kamawada.comE<gt>

=cut

