import 'package:flutter/foundation.dart';

/// An outbound link: a contact channel or a public profile.
@immutable
class ContactLink {
  const ContactLink({
    required this.label,
    required this.value,
    required this.url,
    required this.kind,
  });

  final String label;
  final String value;
  final String url;
  final ContactKind kind;
}

enum ContactKind { email, phone, location, github, linkedin, website, whatsapp }
