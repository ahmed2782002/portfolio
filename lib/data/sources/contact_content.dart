import 'package:portfolio/data/models/models.dart';

abstract final class ContactContent {
  /// Direct channels listed in the CV.
  static const List<ContactLink> contactChannels = [
    ContactLink(
      label: 'Email',
      value: 'ahmedesam2772@gmail.com',
      url: 'mailto:ahmedesam2772@gmail.com',
      kind: ContactKind.email,
    ),
    ContactLink(
      label: 'Phone',
      value: '+20 101 783 7378',
      url: 'tel:+201017837378',
      kind: ContactKind.phone,
    ),
    ContactLink(
      label: 'Based in',
      value: 'Cairo, Egypt',
      url: '',
      kind: ContactKind.location,
    ),
  ];

  /// Public profiles and messaging channels.
  static const List<ContactLink> socialLinks = <ContactLink>[
    ContactLink(
      label: 'LinkedIn',
      value: 'Ahmed Esam',
      url: 'https://www.linkedin.com/in/ahmed-esam-042032347/',
      kind: ContactKind.linkedin,
    ),
    ContactLink(
      label: 'GitHub',
      value: 'ahmed2782002',
      url: 'https://github.com/ahmed2782002',
      kind: ContactKind.github,
    ),
    ContactLink(
      label: 'WhatsApp',
      value: '+20 101 783 7378',
      url: 'https://wa.me/201017837378',
      kind: ContactKind.whatsapp,
    ),
  ];
}
