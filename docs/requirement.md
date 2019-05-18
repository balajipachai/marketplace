## Purpose
* Sell/Purchase cattle & cow milk

## Stakeholders
* Farmers: Seller / Buyer of Cattle
* Dairy Companies: Buyer of Cow Milk
* Veterinarians: Confirm the health certificates of cattle uploaded by farmers
* Govt: Provides Digital Identity of farms with digital signature.

## Smart Contract
* Farmers Registration
* Animal Registration
* Selection of Seller
* Auction of Cattle or cow milk
  - Transfer of ownership of cattle to Buyer

## UI
* **Farmer reg Page**
* **Animal reg Page**
* **Animal lifecycle maintenance Page**
* **Upload Health Card of Cattle Page**
* **Buy / Sell Page**
* **View all Tx. history**
* Veterinarians
* Govt
* Dairy Company
* **Admin Login & Dashboard**
* Visual Rating of farmers reputation


## Attributes of Stakeholders

1. Cattle
    - UniqieIdentifiactionNumber
    - birthDate
    - sex
    - breed
    - parents (if known)
    - birthToCalf[]
    - type (It can be like commercial cattle or registered cattle.
    - cost
    - color
    - birthWeight

)

2. Farmer
    - UID
    - name
    - state
    - district
    - block
    - subDistrict
    - villageTown
    - birthDate
    - gender
    - qualification
    - holdings
        - sector
        - category
        - crop

3. Government
    - govOrgName
    - contactNumber
        - state
        - district
        - block 
        - subDistrict
    - emailId

4. Dairy Company
    - name
    - orgName
    - address
        - state
        - district
        - block
        - subDistrict

5. Milk
    - cattleNo
    - cow/buffalo
    - fatContent
    - proteinContent
    - quantity
    - price
    - timeStamp