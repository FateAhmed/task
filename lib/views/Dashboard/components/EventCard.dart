import 'package:flutter/material.dart';
import 'package:hiring_task/models/RentalItem.dart';
import 'package:hiring_task/utils/AppColors.dart';
import 'package:hiring_task/utils/AppDimens.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  final EventItem eventItem;
  const EventCard({
    super.key,
    required this.eventItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 10,
            blurRadius: 10,
          )
        ],
      ),
      height: 150,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 150,
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: Image.asset(
                'assets/images/img.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppDimens.sizebox5,
                Text(
                  maxLines: 1,
                  eventItem.title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                AppDimens.sizebox2,
                Text(
                  maxLines: 3,
                  eventItem.description,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                Text(
                  eventItem.location,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                ),
                Text(
                  DateFormat('dd/mm/yy hh:mm aa').format(eventItem.eventTime),
                  style: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                ),
                AppDimens.sizebox5,
              ],
            ),
          ),
          AppDimens.sizebox10
        ],
      ),
    );
  }
}
