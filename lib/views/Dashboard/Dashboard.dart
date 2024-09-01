import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hiring_task/models/RentalItem.dart';
import 'package:hiring_task/router/RouteConstants.dart';
import 'package:hiring_task/utils/AppDimens.dart';
import 'package:hiring_task/utils/AppStyles.dart';
import 'package:hiring_task/utils/Validatioms.dart';
import 'package:hiring_task/views/Dashboard/components/EventCard.dart';
import 'package:hiring_task/widgets/CustomTextFormField.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  List<EventItem> events = [];
  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    events = context.watch<List<EventItem>>();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(RouteConstants.createEvent),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text('Dashboard'),
        backgroundColor: Colors.black,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
        actions: const [
          Icon(Icons.search, color: Colors.white, size: 25),
          AppDimens.sizebox10,
          Icon(Icons.add, color: Colors.white, size: 25),
          AppDimens.sizebox10,
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            AppDimens.sizebox10,
            TabBar(
              isScrollable: true,
              padding: EdgeInsets.zero,
              controller: _tabController,
              dividerColor: Colors.white,
              indicatorColor: Colors.black,
              tabAlignment: TabAlignment.center,
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w300),
              labelPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              labelStyle: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
              tabs: const [
                Text('Events'),
                Text('Teams'),
                Text('Tasks'),
                Text('Equipment'),
              ],
            ),
            AppDimens.sizebox20,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomTextFormField(
                      controller: TextEditingController(),
                      focusNode: FocusNode(),
                      validator: notEmpty,
                      inputDecoration: TextFieldStyle.outlined().copyWith(
                        suffixIcon: const Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        hintText: 'Search here!',
                      ),
                    ),
                  ),
                  AppDimens.sizebox15,
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Recent', style: TextStyle(fontSize: 18)),
                  ),
                  AppDimens.sizebox10,
                  if (events.isNotEmpty)
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ...events.map(
                              (e) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: EventCard(eventItem: e),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  events.isEmpty
                      ? const Expanded(child: Center(child: Text('No Events Found')))
                      : const SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
