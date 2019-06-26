# AR Robot State

AR Robot State ist eine Augmented Reality Anwendung für iOS, die es ermöglicht Roboter des Embedded Robotics Lab ([EmRoLab](https://www.htwsaar.de/ingwi/labore/labore-des-studienbereich-informatik/Embedded%20Robotics)) der Hochschule für Technik und Wirtschaft des Saarlandes (htw saar) zu erkennen und Statusinformationen einzublenden. 

Die Anwendung basiert auf ARKit. Mithilfe der vom Framework bereitgestellten Bilderkennung können Roboter identifiziert werden. Nach der Identifizierung eines Roboters werden die Statusinformationen des Roboters im Kamerabild der Anwendung eingeblendet. Die Statusinformationen werden der Anwendung über ein Backend zur Verfügung gestellt. Das Backend basiert auf Firebase. Über eine REST-Schnittstelle aktualisieren die Roboter die im Backend gespeicherten Statusinformationen periodisch. Die AR-Anwendung wird daraufhin vom Backend aktiv über die Änderungen benachrichtigt. 

---

AR Robot State is an Augmented Reality application for iOS, which shows status information for robots from the Embedded Robotics Lab ([EmRoLab](https://www.htwsaar.de/ingwi/labore/labore-des-studienbereich-informatik/Embedded%20Robotics)) of the Saarland University of Applied Sciences (htw saar).

The application is based on ARKit. Using the image recognition provided by the framework, robots can be identified. After identifying a robot, the status information of the robot is displayed in the camera image of the application. The status information is provided to the application via a backend. The backend is based on Firebase. Using a REST interface, the robots periodically update the status information stored in the backend. The AR application is then actively notified by the backend of the changes.

## Lizenz
[GNU General Public License v3.0](https://github.com/htw-saar-informatik/ARRobotState/blob/master/LICENSE)
