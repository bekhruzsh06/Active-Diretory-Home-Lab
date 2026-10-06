## **1. Creating and Linking GPO**

- On your Windows Server, open **Server Manager** -> **Tools** -> **Group Policy Management**.
    
- Expand the tree on the left: **Forest: bek.local** -> **Domains** -> **bek.local**.



<img width="1651" height="910" alt="изображение" src="https://github.com/user-attachments/assets/4ac1206f-b6e3-4334-9dba-131ef9165fac" />

<br>
<br>

<img width="1572" height="876" alt="изображение" src="https://github.com/user-attachments/assets/7696a448-dbc2-4047-bcda-08abf1ae8784" />

<br>
<br>


<img width="1215" height="321" alt="изображение" src="https://github.com/user-attachments/assets/fc6e93aa-ef53-4073-9153-2031535abf89" />

<br>
<br>

<img width="1816" height="841" alt="изображение" src="https://github.com/user-attachments/assets/a6457e15-634a-491a-baae-abda5dfd6a43" />

<br>
<br>

<img width="1542" height="1159" alt="изображение" src="https://github.com/user-attachments/assets/f1930bbe-e0a7-43d4-b773-4c4df18a1d73" />


<br>
<br>

<img width="630" height="183" alt="изображение" src="https://github.com/user-attachments/assets/04549587-3c74-486f-96bd-b14e730285f9" />


<br>
<br>

Now, if we try to open Control Plane, we will get the following message:

<img width="837" height="206" alt="изображение" src="https://github.com/user-attachments/assets/7afc2d1f-85b9-4b4e-9262-64f81aff1c3b" />



## **2. Creating Share and Restricting Access from Specific Departments**

#### **2.1 Creating a Share**

- Create a Folder `IT_Share`
- Right click, select `Properties` -> `Advanced Sharing` -> Check `Share this folder` box

<br>

<img width="725" height="845" alt="изображение" src="https://github.com/user-attachments/assets/4bdd7259-c9da-46f2-beee-7d49c2ddd13c" />



### **2.2 Creating Security Groups**

- On Server Manager, navigate to Tools -> Active Directory Users and Computers
- Right-click on the **IT** OU -> `New` -> `Group`
- Click the newly created group, name it `SG_IT_Group`

<br>
<br>
<img width="784" height="790" alt="изображение" src="https://github.com/user-attachments/assets/daa1eef4-a235-4a0e-856e-8669aa2d6067" />


- Add all members of the IT OU

<br>

<img width="781" height="802" alt="изображение" src="https://github.com/user-attachments/assets/5d1ea752-4926-477e-82fa-eaddf167b380" />
<br>
<br>



### **2.3 Assigning Permissions**

- Rigght click on a shared folder -> `Properties` -> `Security` Tab -> `Edit`

- Add our Security Group to permissions list and specify permissions


<br>
<img width="704" height="791" alt="изображение" src="https://github.com/user-attachments/assets/a36a9700-6207-460b-80ca-b557dcd49d11" />
<br>
<br>

Apply the same steps to the Marketing OU



### **2.4 Results**

Now, if we try to open IT_Share as Bob or Alice (IT OU) from an IT department, we do that, but when we try to open it as a Tim (Marketing OU)

<br>
<img width="2011" height="628" alt="изображение" src="https://github.com/user-attachments/assets/6f25956a-28c9-41ff-aa75-45dc1e022c83" />

<br>
<br>

<img width="1856" height="1104" alt="изображение" src="https://github.com/user-attachments/assets/9cdf4179-ac1e-422e-b8a1-ad90fe510b3e" />
<br>
<br>

Same, but reverse with marketing OU
<br>
<br>
<img width="2010" height="507" alt="изображение" src="https://github.com/user-attachments/assets/73614f90-c1bd-486a-9d4d-167cb4bc56f3" />


<br>
<br>
<img width="1631" height="710" alt="изображение" src="https://github.com/user-attachments/assets/fe01dc25-32ac-403c-bd2a-c7b66fc1e0d2" />
