/// Personクラス（%JSON.Adapterクラス継承）
Class Test.Person Extends (%Persistent, %JSON.Adaptor)
{

/// 名前
Property Name As %Library.String;

/// メール
Property Email As %Library.String;

Storage Default
{
<Data name="PersonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Email</Value>
</Value>
</Data>
<DataLocation>^Test.PersonD</DataLocation>
<DefaultData>PersonDefaultData</DefaultData>
<IdLocation>^Test.PersonD</IdLocation>
<IndexLocation>^Test.PersonI</IndexLocation>
<StreamLocation>^Test.PersonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
