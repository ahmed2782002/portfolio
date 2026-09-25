import 'package:portfolio/data/models/models.dart';
import 'package:portfolio/data/sources/projects/book_iraq.dart';
import 'package:portfolio/data/sources/projects/fresh_driver.dart';
import 'package:portfolio/data/sources/projects/laundo.dart';
import 'package:portfolio/data/sources/projects/laundo_delivery.dart';
import 'package:portfolio/data/sources/projects/qarar.dart';
import 'package:portfolio/data/sources/projects/quartz.dart';
import 'package:portfolio/data/sources/projects/yourseat.dart';

/// Featured case studies, in the order the switcher shows them.
///
/// `hasDeviceFrame` records whether the supplied asset *already* contains a
/// phone mockup. Qarar, Book Iraq, Fresh Driver and Quartz ship as store
/// graphics that are already framed; Laundo, Laundo Delivery and YourSeat are
/// raw screenshots that the UI wraps in its own device frame.
abstract final class ProjectsContent {
  static const List<Project> featured = [
    laundoProject,
    laundoDeliveryProject,
    qararProject,
    bookIraqProject,
    freshDriverProject,
    quartzProject,
    yourSeatProject,
  ];
}
