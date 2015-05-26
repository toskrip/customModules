/*
 * Copyright (c) 2015 LabKey Corporation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.labkey.hdrl.view;

/**
 * Created by binalpatel on 5/12/15.
 */
public class InboundSpecimenBean
{
    private String _customerBarCode;
    private String _lastName;
    private String _firstName;
    private String _middleName;
    private String _birthDate;
    private String _ssn;
    private String _fmpCode;
    private String _ducCode;
    private String _sotCode;
    private String _drawDate;
    private String _specimenType = "Serum"; //for now.

    public String getCustomerBarCode()
    {
        return _customerBarCode;
    }

    public void setCustomerBarCode(String customerBarCode)
    {
        _customerBarCode = customerBarCode;
    }

    public String getLastName()
    {
        return _lastName;
    }

    public void setLastName(String lastName)
    {
        _lastName = lastName;
    }

    public String getFirstName()
    {
        return _firstName;
    }

    public void setFirstName(String firstName)
    {
        _firstName = firstName;
    }

    public String getMiddleName()
    {
        return _middleName;
    }

    public void setMiddleName(String middleName)
    {
        _middleName = middleName;
    }

    public String getBirthDate()
    {
        return _birthDate;
    }

    public void setBirthDate(String birthDate)
    {
        _birthDate = birthDate;
    }

    public String getSsn()
    {
        return _ssn;
    }

    public void setSsn(String ssn)
    {
        _ssn = ssn;
    }

    public String getFmpCode()
    {
        return _fmpCode;
    }

    public void setFmpCode(String fmpCode)
    {
        _fmpCode = fmpCode;
    }

    public String getDucCode()
    {
        return _ducCode;
    }

    public void setDucCode(String ducCode)
    {
        _ducCode = ducCode;
    }

    public String getSotCode()
    {
        return _sotCode;
    }

    public void setSotCode(String sotCode)
    {
        _sotCode = sotCode;
    }

    public String getDrawDate()
    {
        return _drawDate;
    }

    public void setDrawDate(String drawDate)
    {
        _drawDate = drawDate;
    }

    public String getSpecimenType()
    {
        return _specimenType;
    }

    public void setSpecimenType(String specimenType)
    {
        _specimenType = specimenType;
    }

}