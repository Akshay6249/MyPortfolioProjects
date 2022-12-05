--Cleaning Data in SQL Quaries
--#Changing the table name(!)

SELECT * FROM PortfolioProjects..NashvilleHousing


--Standardize Date FORMAT
SELECT SaleDateConverted, 
CONVERT(DATE,SaleDate) FROM PortfolioProjects..NashvilleHousing 

UPDATE NashvilleHousing
SET SaleDate = CONVERT(DATE,SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(DATE,SaleDate)

---Populate Property Adress data ---

SELECT  PropertyAddress
FROM PortfolioProjects..NashvilleHousing 
where PropertyAddress is null

SELECT  *
FROM PortfolioProjects..NashvilleHousing 
--where PropertyAddress is null
order by ParcelID

SELECT  a.ParcelID, a.PropertyAddress, b.ParcelID, B.PropertyAddress
FROM PortfolioProjects..NashvilleHousing A
JOIN PortfolioProjects..NashvilleHousing B
ON A.ParcelID = B.ParcelID
AND A.[UniqueID ] <> B.[UniqueID ]
where A.PropertyAddress is null

SELECT  a.ParcelID, a.PropertyAddress, b.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress,B.PropertyAddress)
FROM PortfolioProjects..NashvilleHousing A
JOIN PortfolioProjects..NashvilleHousing B
ON A.ParcelID = B.ParcelID
AND A.[UniqueID ] <> B.[UniqueID ]
where A.PropertyAddress is null

--use alias while joining the table(1)
UPDATE A
SET PropertyAddress =ISNULL(A.PropertyAddress,B.PropertyAddress)
FROM PortfolioProjects..NashvilleHousing A
JOIN PortfolioProjects..NashvilleHousing B
ON A.ParcelID = B.ParcelID
AND A.[UniqueID ] <> B.[UniqueID ]
where A.PropertyAddress is null
--Now updated check with out null (2)
SELECT  a.ParcelID, a.PropertyAddress, b.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress,B.PropertyAddress)
FROM PortfolioProjects..NashvilleHousing A
JOIN PortfolioProjects..NashvilleHousing B
ON A.ParcelID = B.ParcelID
AND A.[UniqueID ] <> B.[UniqueID ]


----BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS (ADDRESS,CITY,STATE)---

SELECT  PropertyAddress
FROM PortfolioProjects..NashvilleHousing 
--where PropertyAddress is null
--order by ParcelID

--Will Take the First Value and seprating into two
SELECT
SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1) as ADDRESS
,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as ADDRESS

FROM PortfolioProjects..NashvilleHousing


ALTER TABLE PortfolioProjects..NashvilleHousing 
ADD PropertySplitAddress NVARCHAR (255)

UPDATE PortfolioProjects..NashvilleHousing 
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE PortfolioProjects..NashvilleHousing 
ADD PropertySplitCity NVARCHAR(255);

UPDATE PortfolioProjects..NashvilleHousing 
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

SELECT * FROM
PortfolioProjects..NashvilleHousing 

-- ONE MORE DIFFERNT WAYBTO DO IT 
(1)

SELECT Owneraddress
FROM PortfolioProjects.dbo.NashvilleHousing

SELECT
PARSENAME(REPLACE(Owneraddress,',','.'),3)
,PARSENAME(REPLACE(Owneraddress,',','.'),2)
,PARSENAME(REPLACE(Owneraddress,',','.'),1)
FROM PortfolioProjects.dbo.NashvilleHousing

ALTER TABLE PortfolioProjects..NashvilleHousing 
ADD OwnerSplitAddress NVARCHAR (255)

UPDATE PortfolioProjects..NashvilleHousing 
SET OwnerSplitAddress = PARSENAME(REPLACE(Owneraddress,',','.'),3)

ALTER TABLE PortfolioProjects..NashvilleHousing 
ADD OwnerSplitCity NVARCHAR(255);

UPDATE PortfolioProjects..NashvilleHousing 
SET OwnerSplitCity = PARSENAME(REPLACE(Owneraddress,',','.'),2)

ALTER TABLE PortfolioProjects..NashvilleHousing 
ADD OwnerState NVARCHAR(255);

UPDATE PortfolioProjects..NashvilleHousing 
SET OwnerState = PARSENAME(REPLACE(Owneraddress,',','.'),1)

SELECT * FROM
PortfolioProjects..NashvilleHousing 


---CHANGE Y AND N TO YES AND NO IN "SOLD AS VACANT" FILED

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
 FROM PortfolioProjects.dbo.NashvilleHousing 
 GROUP BY SoldAsVacant
 ORDER BY 2

 SELECT SoldAsVacant,
 CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
  WHEN SoldAsVacant = 'N' THEN 'No'
  ELSE  SoldAsVacant
   END
 FROM PortfolioProjects.dbo.NashvilleHousing 

 UPDATE PortfolioProjects.dbo.NashvilleHousing  
 SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
  WHEN SoldAsVacant = 'N' THEN 'No'
  ELSE SoldAsVacant
   END


---REMOVE DUPLICATES
WITH RowNumCTE AS(
SELECT *,
  ROW_NUMBER() OVER (
  PARTITION BY ParcelID,
               PropertyAddress,
			   SalePrice,
			   SaleDate,
			   LegalReference
			   ORDER BY
			   UniqueID
			   ) row_num
FROM PortfolioProjects..NashvilleHousing 
--ORDER BY ParcelID
)
--SELECT *
DELETE
FROM RowNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress



---DELETE UNUSED COLUMNS
--NOT NSRY

SELECT * FROM
PortfolioProjects..NashvilleHousing 

ALTER TABLE PortfolioProjects..NashvilleHousing 
DROP COLUMN OwnerAddress,TaxDistrict,PropertyAddress,

ALTER TABLE PortfolioProjects..NashvilleHousing
DROP COLUMN SaleDate