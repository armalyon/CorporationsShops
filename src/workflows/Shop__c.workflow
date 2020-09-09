<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>New_Shop_created_alert</fullName>
        <description>New Shop created alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>a.r.malyon@epam.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/New_Shop_opened</template>
    </alerts>
    <rules>
        <fullName>Shop_Created_Email</fullName>
        <actions>
            <name>New_Shop_created_alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>TRUE</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
