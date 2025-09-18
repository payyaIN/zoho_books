import 'package:intl/intl.dart';

String formatDate(String apiDate) {
  DateTime parsedDate = DateTime.parse(apiDate);
  String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
  return formattedDate;
}




// billStatus = 3 = open
// billStatus = 6 = paid
// billStatus = 1 = pending


// isBillVerified = 1 = green
// isBillVerified = 0 = red


 
        
            


            //  "billStatus": 1,        "pending"
            // "isBillVerified": 0,





            //     "billStatus": 6,         "paid"
            // "isBillVerified": 1,

            //  "billStatus": 6,       "paid"
            // "isBillVerified": 1,


            //  "billStatus": 6,            "paid"
            // "isBillVerified": 1,


          
          
          
          
          
          
          
          
          
          
            //   "billStatus": 3,         "open"
            // "isBillVerified": 1,


            //   "billStatus": 3,       "open"
            // "isBillVerified": 1,


            //   "billStatus": 3,       "open"
            // "isBillVerified": 1,


