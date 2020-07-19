/// Business logic class defined by OpenAPI in crud2.spec<br/>
/// Created Jul 11, 2020 08:57:39
Class crud2.impl Extends %REST.Impl [ ProcedureBlock ]
{

/// If ExposeServerExceptions is true, then details of internal errors will be exposed.
Parameter ExposeServerExceptions = 0;

/// (provide functional description here)
ClassMethod GetAllPerson() As %Stream.Object
{
    set status=""
    try {
        //応答ヘッダの修正
        do ..%SetHeader("Content-Type","application/json")
        do ..%SetHeader("CharSet","utf-8")
        //Person全件取得のためのコード
        set sql="select JSON_OBJECT('Name':Name,'Email':Email ABSENT ON NULL) as json from Test.Person"
        set stmt=##class(%SQL.Statement).%New()
        set status=stmt.%Prepare(sql)
        set rset=stmt.%Execute()
        set root=[]
        while rset.%Next() {
            set obj={}.%FromJSON(rset.%Get("json"))
            do root.%Push(obj)
        }
        return root
    }
    catch ex {
        set status=ex.DisplayString()
    }
    return status
}

/// (provide functional description here)<br/>
/// The method arguments hold values for:<br/>
///     id<br/>
ClassMethod GetPerson(id As %String) As %Stream.Object
{
    set status=""
    try {
        //応答ヘッダの修正
        do ..%SetHeader("Content-Type","application/json")
        do ..%SetHeader("CharSet","utf-8")
     
        //指定IDのPersonをオープン
        set person=##class(Test.Person).%OpenId(id)
        set status=person.%JSONExportToStream(.stream)
        return stream
    }
    catch ex {
        set status=ex.DisplayString()
    }
    return status
}

/// (provide functional description here)<br/>
/// The method arguments hold values for:<br/>
///     id<br/>
///     payloadBody, Request body contents<br/>
ClassMethod UpdatePerson(id As %String, payloadBody As %Stream.Object) As %Stream.Object
{
    set status=""
    try {
        //応答ヘッダの修正
        do ..%SetHeader("Content-Type","application/json")
        do ..%SetHeader("CharSet","utf-8")
     
        //変更対象のTest.Personをオープン
        set person=##class(Test.Person).%OpenId(id)
        set status=person.%JSONImport(payloadBody)
        set status=person.%Save()
        $$$THROWONERROR(ex,status)
        return stream
    }
    catch ex {
        set status=ex.DisplayString()
    }
    return status
}

/// (provide functional description here)<br/>
/// The method arguments hold values for:<br/>
///     id<br/>
ClassMethod DeletePerson(id As %String) As %Stream.Object
{
    set status=""
    try {
        //応答ヘッダの修正
        do ..%SetHeader("Content-Type","application/json")
        do ..%SetHeader("CharSet","utf-8")     
       //1件削除
        set status=##class(Test.Person).%DeleteId(id)        
        $$$THROWONERROR(ex,status)
    }
    catch ex {
        set status=ex.DisplayString()
    }
    return status
}

/// (provide functional description here)<br/>
/// The method arguments hold values for:<br/>
///     payloadBody, Request body contents<br/>
ClassMethod CreatePerson(payloadBody As %Stream.Object) As %Stream.Object
{
    set status=""
    try {
        //応答ヘッダの修正
        do ..%SetHeader("Content-Type","application/json")
        do ..%SetHeader("CharSet","utf-8")
     
        //JSON文字列からTest.Personのインスタンスへ変換
        set person=##class(Test.Person).%New()
        set status=person.%JSONImport(payloadBody)
        set status=person.%Save()
        $$$THROWONERROR(ex,status)
    }
    catch ex {
        set status=ex.DisplayString()
    }
    return status
}

}
