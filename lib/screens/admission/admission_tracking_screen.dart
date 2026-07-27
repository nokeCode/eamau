import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admission_tracking_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/admission/tracking_header.dart';
import '../../widgets/admission/tracking_info_card.dart';
import '../../widgets/admission/tracking_status_badge.dart';
import '../../widgets/admission/tracking_timeline.dart';
import '../../widgets/admission/tracking_help_card.dart';
import '../../widgets/admission/tracking_bottom_nav.dart';

class AdmissionTrackingScreen extends StatefulWidget{
  const AdmissionTrackingScreen({super.key});
  @override State<AdmissionTrackingScreen> createState()=>_AdmissionTrackingScreenState();
}
class _AdmissionTrackingScreenState extends State<AdmissionTrackingScreen>{
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)=>context.read<AdmissionTrackingProvider>().loadTracking());
  }

  @override
  Widget build(BuildContext context){
    return Consumer<AdmissionTrackingProvider>(builder:(context,p,_){
      return Scaffold(
        backgroundColor: const Color(0xffF5F7FA),
        bottomNavigationBar: TrackingBottomNav(
          currentIndex: 2,
          onTap: (index) {
            switch(index) {
              case 0:
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
                break;
              case 1:
                // Placeholder for schedule/calendar
                break;
              case 3:
                // Placeholder for studies
                break;
              case 4:
                Navigator.pushNamed(context, AppRoutes.profile);
                break;
            }
          },
        ),
        body: SafeArea(child:p.loading?const Center(child:CircularProgressIndicator()):RefreshIndicator(
            onRefresh:p.refreshTracking,
            child:ListView(children:[
              const TrackingHeader(),
              const SizedBox(height:20),
              if(p.tracking!=null)...[
                TrackingInfoCard(reference:p.tracking!.reference,date:p.tracking!.submissionDate,status:p.tracking!.status),
                const SizedBox(height:20),
                Center(child:TrackingStatusBadge(status:p.tracking!.status)),
                Padding(padding:const EdgeInsets.all(20),child:TrackingTimeline(steps:p.tracking!.steps)),
              ],
              TrackingHelpCard(onTap:()=>Navigator.pushNamed(context,AppRoutes.contact)),
              Padding(padding:const EdgeInsets.all(20),child:ElevatedButton(
                  onPressed:p.refreshTracking,
                  child:const Text('Actualiser'))),
            ]))),
      );
    });
  }
}
