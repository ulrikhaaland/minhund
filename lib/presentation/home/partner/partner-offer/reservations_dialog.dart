import 'package:flutter/material.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/partner/partner-reservation/customer_reservation.dart';
import 'package:minhund/service/service_provider.dart';

class ReservationDialog extends StatefulWidget {
  final List<CustomerReservation> customerReservations;

  const ReservationDialog({Key key, this.customerReservations})
      : super(key: key);
  @override
  _ReservationDialogState createState() => _ReservationDialogState();
}

class _ReservationDialogState extends State<ReservationDialog> {
  void deleteReservation({CustomerReservation reservation}) {
    setState(() {
      widget.customerReservations.remove(reservation);
    });
    reservation.docRef.delete();
  }

  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();

    double padding = getDefaultPadding(context);

    return Padding(
      padding: EdgeInsets.all(padding * 2),
      child: Container(
        height: ServiceProvider.instance.screenService
            .getHeightByPercentage(context, 75),
        child: Column(
          children: <Widget>[
            Text(
              "Reservasjoner",
              style: ServiceProvider
                  .instance.instanceStyleService.appStyle.descTitle,
            ),
            ListView.builder(
              key: Key(widget.customerReservations.length.toString()),
              shrinkWrap: true,
              itemCount: widget.customerReservations.length,
              itemBuilder: (context, index) {
                CustomerReservation reservation =
                    widget.customerReservations[index];
                return Row(
                  children: <Widget>[
                    Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ServiceProvider
                              .instance
                              .instanceStyleService
                              .appStyle
                              .borderRadius),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(padding * 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                formatDate(
                                      date: reservation.reservedAt,
                                    ) ??
                                    "",
                                style: ServiceProvider.instance
                                    .instanceStyleService.appStyle.timestamp,
                              ),
                              Container(
                                height: padding,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    "Navn: ",
                                    style: ServiceProvider.instance
                                        .instanceStyleService.appStyle.italic,
                                  ),
                                  Text(reservation.reservationName ?? "N/A",
                                      style: ServiceProvider
                                          .instance
                                          .instanceStyleService
                                          .appStyle
                                          .body1Black),
                                ],
                              ),
                              if (reservation.amount != null)
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Antall: ",
                                      style: ServiceProvider.instance
                                          .instanceStyleService.appStyle.italic,
                                    ),
                                    Text(reservation.amount.toString() ?? "N/A",
                                        style: ServiceProvider
                                            .instance
                                            .instanceStyleService
                                            .appStyle
                                            .body1Black),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          deleteReservation(reservation: reservation),
                      icon: Icon(Icons.delete),
                      iconSize: ServiceProvider.instance.instanceStyleService
                          .appStyle.iconSizeStandard,
                    )
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
