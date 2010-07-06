package WWW::Google::Contacts::Types;

use MooseX::Types -declare =>
    [ qw(
            Category
            Name
            PhoneNumber    ArrayRefOfPhoneNumber
            Email          ArrayRefOfEmail
            IM             ArrayRefOfIM
            Organization   ArrayRefOfOrganization
            PostalAddress  ArrayRefOfPostalAddress
            CalendarLink   ArrayRefOfCalendarLink
            Birthday
    ) ];

use MooseX::Types::Moose qw(Str HashRef ArrayRef Any Undef Bool);

use WWW::Google::Contacts::Type::Category;
use WWW::Google::Contacts::Type::Name;
use WWW::Google::Contacts::Type::PhoneNumber;
use WWW::Google::Contacts::Type::PhoneNumber;
use WWW::Google::Contacts::Type::Email;
use WWW::Google::Contacts::Type::Email;
use WWW::Google::Contacts::Type::IM;
use WWW::Google::Contacts::Type::Organization;
use WWW::Google::Contacts::Type::PostalAddress;
use WWW::Google::Contacts::Type::Birthday;
use WWW::Google::Contacts::Type::CalendarLink;

class_type Category,
    { class => 'WWW::Google::Contacts::Type::Category' };

coerce Category,
    from Any,
    via {
        WWW::Google::Contacts::Type::Category->new(
            type   => 'http://schemas.google.com/g/2005#kind',
            term   => 'http://schemas.google.com/contact/2008#contact'
        );
    };

class_type Name,
    { class => 'WWW::Google::Contacts::Type::Name' };

coerce Name,
    from Str,
    via { WWW::Google::Contacts::Type::Name->new( full_name => $_ ) },
    from Any,
    via { WWW::Google::Contacts::Type::Name->new( $_ || {} ) };

class_type PhoneNumber,
    { class => 'WWW::Google::Contacts::Type::PhoneNumber' };

coerce PhoneNumber,
    from HashRef,
    via { WWW::Google::Contacts::Type::PhoneNumber->new( $_ ) },
    from Str,
    via { WWW::Google::Contacts::Type::PhoneNumber->new( type => "mobile", value => $_ ) };

subtype ArrayRefOfPhoneNumber,
    as ArrayRef[ PhoneNumber ];

coerce ArrayRefOfPhoneNumber,
    from ArrayRef,
    via { return [ map { to_PhoneNumber( $_ ) } @{ $_ } ] },
    from Any,
    via { return [ to_PhoneNumber( $_ ) ] };

class_type Email,
    { class => 'WWW::Google::Contacts::Type::Email' };

coerce Email,
    from HashRef,
    via { WWW::Google::Contacts::Type::Email->new( $_ ) },
    from Str,
    via { WWW::Google::Contacts::Type::Email->new( type => "home", value => $_ ) };

subtype ArrayRefOfEmail,
    as ArrayRef[ Email ];

coerce ArrayRefOfEmail,
    from ArrayRef,
    via { [ map { to_Email( $_ ) } @{ $_ } ] },
    from Any,
    via { [ to_Email( $_ ) ] };

class_type IM,
    { class => 'WWW::Google::Contacts::Type::IM' };

coerce IM,
    from HashRef,
    via { WWW::Google::Contacts::Type::IM->new( $_ ) },
    from Str,
    via { WWW::Google::Contacts::Type::IM->new( value => $_ ) };

subtype ArrayRefOfIM,
    as ArrayRef[ IM ];

coerce ArrayRefOfIM,
    from ArrayRef,
    via { [ map { to_IM( $_ ) } @{ $_ } ] },
    from Any,
    via { [ to_IM( $_ ) ] };

class_type Organization,
    { class => 'WWW::Google::Contacts::Type::Organization' };

coerce Organization,
    from HashRef,
    via { WWW::Google::Contacts::Type::Organization->new( $_ ) },
    from Str,
    via { WWW::Google::Contacts::Type::Organization->new( type => "work", name => $_ ) };

subtype ArrayRefOfOrganization,
    as ArrayRef[ Organization ];

coerce ArrayRefOfOrganization,
    from ArrayRef,
    via { [ map { to_Organization( $_ ) } @{ $_ } ] },
    from Any,
    via { [ to_Organization( $_ ) ] };

class_type PostalAddress,
    { class => 'WWW::Google::Contacts::Type::PostalAddress' };

coerce PostalAddress,
    from HashRef,
    via { WWW::Google::Contacts::Type::PostalAddress->new( $_ ) },
    from Str,
    via { WWW::Google::Contacts::Type::PostalAddress->new( type => "work", formatted => $_ ) };

subtype ArrayRefOfPostalAddress,
    as ArrayRef[ PostalAddress ];

coerce ArrayRefOfPostalAddress,
    from ArrayRef,
    via { [ map { to_PostalAddress( $_ ) } @{ $_ } ] },
    from Any,
    via { [ to_PostalAddress( $_ ) ] };

class_type Birthday,
    { class => 'WWW::Google::Contacts::Type::Birthday' };

coerce Birthday,
    from Str,
    via { WWW::Google::Contacts::Type::Birthday->new( when => $_ ) },
    from HashRef,
    via { WWW::Google::Contacts::Type::Birthday->new( $_ ) };

class_type CalendarLink,
    { class => 'WWW::Google::Contacts::Type::CalendarLink' };

coerce CalendarLink,
    from HashRef,
    via { WWW::Google::Contacts::Type::CalendarLink->new( $_ ) },
    from Str,
    via { WWW::Google::Contacts::Type::CalendarLink->new( type => "home", href => $_ ) };

subtype ArrayRefOfCalendarLink,
    as ArrayRef[ CalendarLink ];

coerce ArrayRefOfCalendarLink,
    from ArrayRef,
    via { [ map { to_CalendarLink( $_ ) } @{ $_ } ] },
    from Any,
    via { [ to_CalendarLink( $_ ) ] };
