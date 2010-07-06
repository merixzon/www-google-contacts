package WWW::Google::Contacts::Types;

use MooseX::Types -declare =>
    [ qw(
            Category
            Name
            PhoneNumber
            Email
            IM
            Organization
            PostalAddress
            CalendarLink ArrayRefOfCalendarLink

            ArrayRefOfPhoneNumber
            ArrayRefOfEmail
            ArrayRefOfIM
            ArrayRefOfOrganization
            ArrayRefOfPostalAddress

            Birthday

            XmlBool
            Rel
    ) ];

use MooseX::Types::Moose qw(Str HashRef ArrayRef Any Undef Bool);

class_type Rel,
    { class => 'WWW::Google::Contacts::Type::Rel' };

coerce Rel,
    from Str,
    via {
        require WWW::Google::Contacts::Type::Rel;
        WWW::Google::Contacts::Type::Rel->new(
            ($_ =~ m{^http})
                ? ( uri => $_ )
                    : ( name => $_ ),
        );
    };

class_type Category,
    { class => 'WWW::Google::Contacts::Type::Category' };

coerce Category,
    from Any,
    via {
        require WWW::Google::Contacts::Type::Category;
        WWW::Google::Contacts::Type::Category->new(
            type   => 'http://schemas.google.com/g/2005#kind',
            term   => 'http://schemas.google.com/contact/2008#contact'
        );
    };

class_type Name,
    { class => 'WWW::Google::Contacts::Type::Name' };

coerce Name,
    from Str,
    via {
        require WWW::Google::Contacts::Type::Name;
        WWW::Google::Contacts::Type::Name->new( full_name => $_ );
    },
    from Any,
    via {
        require WWW::Google::Contacts::Type::Name;
        WWW::Google::Contacts::Type::Name->new( $_ || {} );
    };

class_type PhoneNumber,
    { class => 'WWW::Google::Contacts::Type::PhoneNumber' };

coerce PhoneNumber,
    from HashRef,
    via {
        require WWW::Google::Contacts::Type::PhoneNumber;
        WWW::Google::Contacts::Type::PhoneNumber->new( $_ );
    },
    from Str,
    via {
        require WWW::Google::Contacts::Type::PhoneNumber;
        WWW::Google::Contacts::Type::PhoneNumber->new( type => "mobile", value => $_ );
    };

subtype ArrayRefOfPhoneNumber,
    as ArrayRef[ PhoneNumber ];

coerce ArrayRefOfPhoneNumber,
    from ArrayRef,
    via {
        require WWW::Google::Contacts::Type::PhoneNumber;
        return [ map { to_PhoneNumber( $_ ) } @{ $_ } ];
    },
    from Any,
    via {
        require WWW::Google::Contacts::Type::PhoneNumber;
        return [ to_PhoneNumber( $_ ) ];
    };

class_type Email,
    { class => 'WWW::Google::Contacts::Type::Email' };

coerce Email,
    from HashRef,
    via {
        require WWW::Google::Contacts::Type::Email;
        WWW::Google::Contacts::Type::Email->new( $_ );
    },
    from Str,
    via {
        require WWW::Google::Contacts::Type::Email;
        WWW::Google::Contacts::Type::Email->new( type => "home", value => $_ );
    };

subtype ArrayRefOfEmail,
    as ArrayRef[ Email ];

coerce ArrayRefOfEmail,
    from ArrayRef,
    via {
        require WWW::Google::Contacts::Type::Email;
        return [ map { to_Email( $_ ) } @{ $_ } ];
    },
    from Any,
    via {
        require WWW::Google::Contacts::Type::Email;
        return [ to_Email( $_ ) ];
    };

class_type IM,
    { class => 'WWW::Google::Contacts::Type::IM' };

coerce IM,
    from HashRef,
    via {
        require WWW::Google::Contacts::Type::IM;
        WWW::Google::Contacts::Type::IM->new( $_ );
    },
    from Str,
    via {
        require WWW::Google::Contacts::Type::IM;
        WWW::Google::Contacts::Type::IM->new( value => $_ );
    };

subtype ArrayRefOfIM,
    as ArrayRef[ IM ];

coerce ArrayRefOfIM,
    from ArrayRef,
    via {
        require WWW::Google::Contacts::Type::IM;
        return [ map { to_IM( $_ ) } @{ $_ } ];
    },
    from Any,
    via {
        require WWW::Google::Contacts::Type::IM;
        return [ to_IM( $_ ) ];
    };

class_type Organization,
    { class => 'WWW::Google::Contacts::Type::Organization' };

coerce Organization,
    from HashRef,
    via {
        require WWW::Google::Contacts::Type::Organization;
        WWW::Google::Contacts::Type::Organization->new( $_ );
    },
    from Str,
    via {
        require WWW::Google::Contacts::Type::Organization;
        WWW::Google::Contacts::Type::Organization->new( type => "work", name => $_ );
    };

subtype ArrayRefOfOrganization,
    as ArrayRef[ Organization ];

coerce ArrayRefOfOrganization,
    from ArrayRef,
    via {
        require WWW::Google::Contacts::Type::Organization;
        return [ map { to_Organization( $_ ) } @{ $_ } ];
    },
    from Any,
    via {
        require WWW::Google::Contacts::Type::Organization;
        return [ to_Organization( $_ ) ];
    };

class_type PostalAddress,
    { class => 'WWW::Google::Contacts::Type::PostalAddress' };

coerce PostalAddress,
    from HashRef,
    via {
        require WWW::Google::Contacts::Type::PostalAddress;
        WWW::Google::Contacts::Type::PostalAddress->new( $_ );
    },
    from Str,
    via {
        require WWW::Google::Contacts::Type::PostalAddress;
        WWW::Google::Contacts::Type::PostalAddress->new( type => "work", formatted => $_ );
    };

subtype ArrayRefOfPostalAddress,
    as ArrayRef[ PostalAddress ];

coerce ArrayRefOfPostalAddress,
    from ArrayRef,
    via {
        require WWW::Google::Contacts::Type::PostalAddress;
        return [ map { to_PostalAddress( $_ ) } @{ $_ } ];
    },
    from Any,
    via {
        require WWW::Google::Contacts::Type::PostalAddress;
        return [ to_PostalAddress( $_ ) ];
    };


subtype XmlBool,
    as Bool;

coerce XmlBool,
    from Str,
    via {
        return 1 if ( $_ =~ m{^true$}i );
        return 0;
    };

class_type Birthday,
    { class => 'WWW::Google::Contacts::Type::Birthday' };

coerce Birthday,
    from Str,
    via {
        require WWW::Google::Contacts::Type::Birthday;
        WWW::Google::Contacts::Type::Birthday->new( when => $_ );
    },
    from HashRef,
    via {
        require WWW::Google::Contacts::Type::Birthday;
        WWW::Google::Contacts::Type::Birthday->new( $_ );
    };

class_type CalendarLink,
    { class => 'WWW::Google::Contacts::Type::CalendarLink' };

coerce CalendarLink,
    from HashRef,
    via {
        require WWW::Google::Contacts::Type::CalendarLink;
        WWW::Google::Contacts::Type::CalendarLink->new( $_ );
    },
    from Str,
    via {
        require WWW::Google::Contacts::Type::CalendarLink;
        WWW::Google::Contacts::Type::CalendarLink->new( type => "home", href => $_ );
    };

subtype ArrayRefOfCalendarLink,
    as ArrayRef[ CalendarLink ];

coerce ArrayRefOfCalendarLink,
    from ArrayRef,
    via {
        require WWW::Google::Contacts::Type::CalendarLink;
        return [ map { to_CalendarLink( $_ ) } @{ $_ } ];
    },
    from Any,
    via {
        require WWW::Google::Contacts::Type::CalendarLink;
        return [ to_CalendarLink( $_ ) ];
    };
