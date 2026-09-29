
## Stage 1: Design

The purpose of this stage is to design a logical diagram and explain a reader how the infrastructure is working. 

<img width="655" height="660" alt="Active Directory Scheme drawio(1)" src="https://github.com/user-attachments/assets/d8f1c96f-9bab-4b55-af3d-0a06a90e3790" />

#### Workflow

As seen from graph, 3 PCs are interacting with DC via isolated virtual network as a security measure.


### Stage 2: Setting Up Domain Controller

#### **2.1 Setting static IP address and DNS** 

1.  Press Win+R, type `ncpa.cpl`, select Properties -> IPv4 and configure as below

  <img width="875" height="810" alt="изображение" src="https://github.com/user-attachments/assets/8404e78c-b615-44a8-8eb1-e8bc0379bdac" />

2. Open **Server Manager**, click **Local Server** on the left, and click the randomly generated string next to **Computer name**.

<img width="1242" height="522" alt="изображение" src="https://github.com/user-attachments/assets/717f3215-6c14-4668-b865-b41cc0893fc9" />

#### **2.2 Install the Active Directory Role**

1. Once rebooted, log back in.

- Open Server Manager

- Select `Manage` on the right top corner

- Click **Next** until you reach the **Server Roles** screen.
    
- Check the box for **Active Directory Domain Services**.

<img width="1187" height="395" alt="изображение" src="https://github.com/user-attachments/assets/b9abfd0e-b7f1-4dc2-a9e6-d72228b218b6" />

- A small window will pop up; click **Add Features**, then click **Next** through the rest of the wizard.
    
- Click **Install**. Leave the Server Manager window open while it finishes.

 **2.3 Promoting to a Domain Controller**

We installed the necessary tools, now we have to create our own domain

- When the installation finishes, click the **Yellow Notification Flag** at the top top of Server Manager.

  <img width="735" height="145" alt="изображение" src="https://github.com/user-attachments/assets/bac74804-5075-4878-958a-0b77572d9923" />


- Click the blue link **Promote this server to a domain controller**.
- 

 <img width="1711" height="899" alt="изображение" src="https://github.com/user-attachments/assets/9eb995a0-0c2a-47a3-b43f-e9ae9ef8d6a9" />

-
- Select **Add a new forest** and type domain name in the box (`bek.local`). Click **Next**.
-

<img width="1656" height="682" alt="изображение" src="https://github.com/user-attachments/assets/79599de0-4a9d-47e0-a933-37d455901c0e" />

-
- Click **Next** through the DNS warning, NetBIOS name, and database paths (leave them all as default).
-

<img width="1670" height="975" alt="изображение" src="https://github.com/user-attachments/assets/58e682de-8dac-47d9-87b4-c25037c287de" />

-
- Click **Install**
-

<img width="1672" height="991" alt="изображение" src="https://github.com/user-attachments/assets/c0088bb1-605d-4498-bd9a-8adcea62ac25" />

<img width="474" height="603" alt="изображение" src="https://github.com/user-attachments/assets/eaa7bc9c-b61b-4542-a428-3adfd682960a" />

### Stage 3: Connecting Windows 10 Pro to Windows Server

#### **3.1 Configure Client IP and DNS on Windows 10 Pro**

- Press `Win + R` -> `ncpa.cpl`
-  Right-click the network adapter, select **Properties**, select **Internet Protocol Version 4 (TCP/IPv4)**, and click **Properties**.
    
-  Select **Use the following IP address** and enter:
    
    - **IP address:** `192.168.50.21`
        
    - **Subnet mask:** `255.255.255.0`
        
-  Select **Use the following DNS server addresses** and enter:
    
    - **Preferred DNS server:** `192.168.50.10` (This is Domain Controller's IP).
 
  <img width="587" height="676" alt="изображение" src="https://github.com/user-attachments/assets/8beb2ed1-e71e-49b1-8d9a-6822480a2026" />

-  Click **OK** and **Close**.
    

- _Verification:_ Open Command Prompt and type `ping bek.local` . It should successfully reply from `192.168.50.10`.

<img width="687" height="340" alt="изображение" src="https://github.com/user-attachments/assets/3a4660bd-ef62-4eef-a6ac-667c1e9fc22b" />


#### **3.2 Join the Domain**

- Press `Win + R` and type `sysdm.cpl`

-  Set description if you want and click **Change** button below

  <img width="476" height="587" alt="изображение" src="https://github.com/user-attachments/assets/d68935cc-72b7-4a31-83c3-34a6897a4a9e" />

-
- Set **Computer name** and Select Member of: **Domain** and set the domain name (`bek.local`)
-

<img width="1661" height="945" alt="изображение" src="https://github.com/user-attachments/assets/25fb97d3-2dca-4578-a40b-43301c2dac5e" />

- Click **OK**, enter Administrator creds and restart VM

#### **3.3 Verify the Connection on the Server**

- Open Server Manager on our `DC-01`
- Click `Tools` -> **Active Directory Users and Computers**
- Select `bek.local` -> `computers`

![Uploading изображение.png…]()

 And there is Alice's account here
