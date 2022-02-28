Select *
From dbo.NashvilleHousing



-----------------------------------------------------------------------------------------------------------------------

--Standartdize date format

Select SaleDateConverted, CONVERT(Date,SaleDate)
From dbo.NashvilleHousing

update NashvilleHousing
set SaleDate = CONVERT(Date,SaleDate)

Alter table NashvilleHousing
add SaleDateConverted Date;

update NashvilleHousing
set SaleDateConverted = CONVERT(Date,SaleDate)



-----------------------------------------------------------------------------------------------------------------------

--Populate Property Address Data

Select *
From dbo.NashvilleHousing
Where PropertyAddress is null

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From dbo.NashvilleHousing a
join dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and  a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From dbo.NashvilleHousing a
join dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and  a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null





-----------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Colums (Address, City, State)


Select PropertyAddress
From dbo.NashvilleHousing


Select
SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1) as Adress
,SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress)) as City
From dbo.NashvilleHousing


Alter table NashvilleHousing
add PropertySplitAdress Nvarchar(255);

update NashvilleHousing
set PropertySplitAdress = SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1)

Alter table NashvilleHousing
add PropertySplitCity Nvarchar(255);

update NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress))

Select *
From dbo.NashvilleHousing



Select OwnerAddress
From dbo.NashvilleHousing


Select 
PARSENAME(Replace(OwnerAddress, ',', '.') ,3) as Adress
,PARSENAME(Replace(OwnerAddress, ',', '.') ,2) as City
,PARSENAME(Replace(OwnerAddress, ',', '.') ,1) as State
From dbo.NashvilleHousing

Alter table NashvilleHousing
add OwnerSplitAdress Nvarchar(255);

update NashvilleHousing
set OwnerSplitAdress = PARSENAME(Replace(OwnerAddress, ',', '.') ,3) 

Alter table NashvilleHousing
add OwnerSplitCity Nvarchar(255);

update NashvilleHousing
set OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',', '.') ,2)

Alter table NashvilleHousing
add OwnerSplitState Nvarchar(255);

update NashvilleHousing
set OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',', '.') ,1)

Select *
From dbo.NashvilleHousing



-----------------------------------------------------------------------------------------------------------------------


--Change Y and N to Yes and No in "Sold As Vacant" field

Select Distinct SoldAsVacant
From dbo.NashvilleHousing



Select SoldAsVacant
,CASE when SoldAsVacant = 'Y' THEN 'Yes'
	when SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
	END
From dbo.NashvilleHousing

update NashvilleHousing
set SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'Yes'
	when SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
	END



-----------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
ROW_NUMBER() OVER (
Partition by ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference ORDER BY UniqueID) row_num
From dbo.NashvilleHousing
--Order by ParcelID
)

Select *
From RowNumCTE
where row_num >1

--Delete
--From RowNumCTE
--where row_num >1



-----------------------------------------------------------------------------------------------------------------------

-- Delete Unused Coloms

Select *
From dbo.NashvilleHousing

Alter table dbo.NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter table dbo.NashvilleHousing
Drop Column SaleDate