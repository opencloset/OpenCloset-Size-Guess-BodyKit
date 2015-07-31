package OpenCloset::Size::Guess::BodyKit;
# ABSTRACT: OpenCloset::Size::Guess driver for the BodyKit service

use utf8;

use Moo;
use Types::Standard qw( Str );

our $VERSION = '0.001';

with 'OpenCloset::Size::Guess::Role::Base';

use HTTP::Tiny;
use JSON;
use Try::Tiny;

#
# to support HTTPS
#
use IO::Socket::SSL;
use Mozilla::CA;
use Net::SSLeay;

#<<< skip perltidy
has accessKey  => ( is => 'ro', isa => Str, required => 1 );
has secret     => ( is => 'ro', isa => Str, required => 1 );
has url        => ( is => 'ro', isa => Str, default  => 'https://api.bodylabs.com/instant/measurements' );
has scheme     => ( is => 'ro', isa => Str, default  => 'flexible' );
has unitSystem => ( is => 'ro', isa => Str, default  => 'metric' );
has generation => ( is => 'ro', isa => Str, default  => '2.0' );
#>>>

sub guess {
    my $self = shift;

    my %ret = (
        height  => $self->height,
        weight  => $self->weight,
        gender  => $self->gender,
        success => 0,
        reason  => q{},
    );

    my $json = JSON::encode_json(
        {
            gender       => $self->gender,
            scheme       => $self->scheme,
            unitSystem   => $self->unitSystem,
            measurements => { height => $self->height +0, weight => $self->weight +0 },
        }
    );

    my $authorization =
        sprintf( "SecretPair accessKey=%s,secret=%s", $self->accessKey, $self->secret );

    my $http = HTTP::Tiny->new(
        default_headers => {
            authorization  => $authorization,
            'content-type' => 'application/x-www-form-urlencoded'
        },
    );
    my $res = $http->post( $self->url, { content => $json } );
    unless ( $res->{success} ) {
        $ret{reason} = "$res->{status}: $res->{content}";
        return \%ret;
    }

    my $data = try { JSON::decode_json( $res->{content} ); };
    unless ($data) {
        $ret{reason} = "failed to decode json string: $res->{content}";
        return \%ret;
    }
    unless ( $data->{output} ) {
        $ret{reason} = "cannot find output key in json: $res->{content}";
        return \%ret;
    }
    unless ( $data->{output}{measurements} ) {
        $ret{reason} = "cannot find output.measurements key in json: $res->{content}";
        return \%ret;
    }

    my $m = $data->{output}{measurements};
    %ret = (
        %ret,
        success  => 1,
        arm      => $m->{side_arm_length},
        belly    => $m->{waist_girth},
        bust     => $m->{bust_girth},
        foot     => 0,
        hip      => $m->{low_hip_girth},
        knee     => $m->{outseam} - $m->{knee_height},
        leg      => $m->{outseam},
        thigh    => $m->{thigh_girth},
        topbelly => 0,
        waist    => $m->{waist_girth},
    );

    return \%ret;
}

1;

# COPYRIGHT

__END__

=for Pod::Coverage BUILDARGS

=head1 SYNOPSIS

    use OpenCloset::Size::Guess;

    # create a database guesser
    my $guesser = OpenCloset::Size::Guess->new(
        'BodyKit',
        height     => 172,
        weight     => 72,
        gender     => 'male',
        _accessKey => 'AK7e9ebc60f395b5fbe9a9436b321dda9e',
        _secret    => 'a8687773b3486067deeddc0c91dbbee8',
    );

    print $guesser->height . "\n";
    print $guesser->weight . "\n";
    print $guesser->gender . "\n";

    # get the body measurement information
    my $info = $guesser->guess;
    print "arm: $info{arm}\n";
    print "belly: $info{belly}\n";
    print "bust: $info{bust}\n";
    print "foot: $info{foot}\n";
    print "hip: $info{hip}\n";
    print "knee: $info{knee}\n";
    print "leg: $info{leg}\n";
    print "thigh: $info{thigh}\n";
    print "topbelly: $info{tobelly}\n";
    print "waist: $info{waist}\n";


=head1 DESCRIPTION

This module is a L<OpenCloset::Size::Guess> driver for the BodyKit service.


=attr height

=attr weight

=attr gender

=attr accessKey

=attr secret

=attr url

=attr scheme

=attr unitSystem

=attr generation


=method guess


=head1 SEE ALSO

=for :list
* L<BodyKit x Developer|http://developer.bodylabs.com/>
* L<Body Labs|http://www.bodylabs.com/>
* L<OpenCloset::Size::Guess>
* L<SMS::Send>
* L<Parcel::Track>
