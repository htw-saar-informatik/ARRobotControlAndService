# AR Robot State

AR Robot State ist eine Augmented Reality Anwendung für iOS, die es ermöglicht Roboter des Embedded Robotoics Lab (EmRoLab) der Hochschule für Technik und Wirtschaft des Saarlandes (htw saar) zu erkennen und Statusinformationen einzublenden. 

Die Anwendung basiert auf ARKit. Mithilfe der vom Framework bereitgestellten Bilderkennung können Roboter identifiziert werden. Nach der Identifizierung eines Roboters werden die Statusinformationen des Roboters im Kamerabild der Anwendung eingeblendet. Die Statusinformationen werden der Anwendung über ein Backend zur Verfügung gestellt. Das Backend basiert auf Firebase. Über eine REST-Schnittstelle aktualisieren die Roboter die im Backend gespeicherten Statusinformationen periodisch. Die AR-Anwendung wird daraufhin vom Backend aktiv über die Änderungen benachrichtigt. 


## Lizenz
[GNU General Public License v3.0](https://github.com/htw-saar-informatik/ARRobotState/blob/master/LICENSE)

---

AR Robot State is an Augmented Reality application for iOS, which allows the detection of robots from the Embedded Robotoics Lab (EmRoLab) of the Saarland University of Applied Sciences (htw saar) and to show status information.

The application is based on ARKit. Using the image recognition provided by the framework, robots can be identified. After identifying a robot, the status information of the robot is displayed in the camera image of the application. The status information is provided to the application via a backend. The backend is based on Firebase. Using a REST interface, the robots periodically update the status information stored in the backend. The AR application is then actively notified by the backend of the changes.

