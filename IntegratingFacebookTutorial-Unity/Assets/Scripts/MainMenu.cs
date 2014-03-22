using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Parse;
using System;
using Facebook;
using Facebook.MiniJSON;
using System.Linq;

public class MainMenu : MonoBehaviour {

	public GUISkin menuSkin;

	public GameObject loggedInUIElements;
	public GameObject loggedOutUIElements;

	public GameObject profilePicture;
	public GameObject nameLabel;
	public GameObject locationLabel;
	public GameObject genderLabel;
	public GameObject birthdayLabel;
	public GameObject relationshipLabel;
	public GameObject welcomeLabel;

	public Texture defaultProfilePictureTexture;

	private TextMesh nameLabelMesh;
	private TextMesh locationLabelMesh;
	private TextMesh genderLabelMesh;
	private TextMesh birthdayLabelMesh;
	private TextMesh relationshipLabelMesh;
	private MeshRenderer profilePictureRenderer;

	Rect loginButtonRect;
	Rect logoutButtonRect;

	private float TextureScale
	{
		get
		{
			#if UNITY_EDITOR
			return 1.0f;
			# else
			return 2.0f;
			#endif
		}
	}

	// Use this for initialization
	void Start () {
		nameLabelMesh = nameLabel.GetComponent<TextMesh>();
		locationLabelMesh = locationLabel.GetComponent<TextMesh>();
		genderLabelMesh = genderLabel.GetComponent<TextMesh>();
		birthdayLabelMesh = birthdayLabel.GetComponent<TextMesh>();
		relationshipLabelMesh = relationshipLabel.GetComponent<TextMesh>();
		profilePictureRenderer = profilePicture.GetComponent<MeshRenderer>();

		float loginButtonWidth =TextureScale * 180.0f;
		float loginButtonHeight = TextureScale * 38.0f;
		float loginButtonX = (Screen.width - loginButtonWidth) / 2.0f;
		loginButtonRect = new Rect (loginButtonX,10,loginButtonWidth,loginButtonHeight);

		float logoutButtonWidth = TextureScale * 90.0f;
		float logoutButtonHeight = TextureScale * 38.0f;
		float logoutButtonX = (Screen.width - logoutButtonWidth) / 2.0f;
		logoutButtonRect = new Rect (logoutButtonX,10,logoutButtonWidth,logoutButtonHeight);

		// Check for a Facebook logged in user
		if (FB.IsLoggedIn) {
			showLoggedIn();
			// Check if we're logged in to Parse
			if (ParseUser.CurrentUser == null) {
				// If not, log in with Parse
				StartCoroutine("ParseLogin");
			} else {
				// Show any user cached profile info
				UpdateProfile();
			}
		} else {
			showLoggedOut();
		}
	}

	void Awake()
	{
		enabled = false;
		FB.Init(SetInit, OnHideUnity);
	}

	private void SetInit()
	{
		enabled = true;
	}

	private void OnHideUnity(bool isGameShown) {
		if (!isGameShown)
		{
			// pause the game - we will need to hide
			Time.timeScale = 0;
		}
		else
		{
			// start the game back up - we're getting focus again
			Time.timeScale = 1;
		}
	}

	void OnGUI() {
		GUI.skin = menuSkin;

		// Check if no Parse user or not logged into Facebook
		// if ((ParseUser.CurrentUser == null) || !FB.IsLoggedIn) {
		if (!FB.IsLoggedIn) {
			if (GUI.Button(loginButtonRect, "", "loginButton"))
			{
				FBLogin();
			}
		} else {
			if (GUI.Button(logoutButtonRect, "", "logoutButton"))
			{
				ParseFBLogout();
			}
		}
	}
	
	private IEnumerator ParseLogin() {
		if (FB.IsLoggedIn) {
			// Logging in with Parse
			var loginTask = ParseFacebookUtils.LogInAsync(FB.UserId, 
			                                              FB.AccessToken, 
			                                              DateTime.Now);
			while (!loginTask.IsCompleted) yield return null;
			// Login completed, check results
			if (loginTask.IsFaulted || loginTask.IsCanceled) {
				// There was an error logging in to Parse
				foreach(var e in loginTask.Exception.InnerExceptions) {
					ParseException parseException = (ParseException) e;
					Debug.Log("ParseLogin: error message " + parseException.Message);
					Debug.Log("ParseLogin: error code: " + parseException.Code);
				}
			} else {
				// Log in to Parse successful
				// Get user info
				FB.API("/me", HttpMethod.GET, FBAPICallback);
				// Display current profile info
				UpdateProfile();
			}
		}
	}

	private void FBLogin() {
		// Logging in with Facebook
		FB.Login("user_about_me, user_relationships, user_birthday, user_location", FBLoginCallback);
	}

	private void FBLoginCallback(FBResult result) {
		// Login callback
		if(FB.IsLoggedIn) {
			showLoggedIn();
			StartCoroutine("ParseLogin");
		} else {
			Debug.Log ("FBLoginCallback: User canceled login");
		}
	}

	private void ParseFBLogout() {
		FB.Logout();
		ParseUser.LogOut();
		showLoggedOut();
	}

	private void FBAPICallback(FBResult result)
	{
		if (!String.IsNullOrEmpty(result.Error)) {
			Debug.Log ("FBAPICallback: Error getting user info: + "+ result.Error);
			// Log the user out, the error could be due to an OAuth exception
			ParseFBLogout();
		} else {
			// Got user profile info
			var resultObject = Json.Deserialize(result.Text) as Dictionary<string, object>;
			var userProfile = new Dictionary<string, string>();
			
			userProfile["facebookId"] = getDataValueForKey(resultObject, "id");
			userProfile["name"] = getDataValueForKey(resultObject, "name");
			object location;
			if (resultObject.TryGetValue("location", out location)) {
				userProfile["location"] = (string)(((Dictionary<string, object>)location)["name"]);
			}
			userProfile["gender"] = getDataValueForKey(resultObject, "gender");
			userProfile["birthday"] = getDataValueForKey(resultObject, "birthday");
			userProfile["relationship"] = getDataValueForKey(resultObject, "relationship_status");
			if (userProfile["facebookId"] != "") {
				userProfile["pictureURL"] = "https://graph.facebook.com/" + userProfile["facebookId"] + "/picture?type=large&return_ssl_resources=1";
			}
			
			var emptyValueKeys = userProfile
				.Where(pair => String.IsNullOrEmpty(pair.Value))
					.Select(pair => pair.Key).ToList();
			foreach (var key in emptyValueKeys) {
				userProfile.Remove(key);
			}
			
			StartCoroutine("saveUserProfile", userProfile);
		}
	}

	private IEnumerator saveUserProfile(Dictionary<string, string> profile) {
		var user = ParseUser.CurrentUser;
		user["profile"] = profile;
		// Save if there have been any updates
		if (user.IsKeyDirty("profile")) {
			var saveTask = user.SaveAsync();
			while (!saveTask.IsCompleted) yield return null;
			UpdateProfile();
		}
	}

	private string getDataValueForKey(Dictionary<string, object> dict, string key) {
		object objectForKey;
		if (dict.TryGetValue(key, out objectForKey)) {
			return (string)objectForKey;
		} else {
			return "";
		}
	}

	private void UpdateProfile() {
		// Display cached info
		var user = ParseUser.CurrentUser;
		IDictionary<string, string> userProfile = user.Get<IDictionary<string, string>>("profile");
		nameLabelMesh.text = ResolveTextSize(userProfile["name"], 12); // Check and wrap words
		locationLabelMesh.text = userProfile.ContainsKey("location") ? ResolveTextSize(userProfile["location"], 25) : "";
		genderLabelMesh.text = userProfile.ContainsKey("gender") ? userProfile["gender"] : "";
		birthdayLabelMesh.text = userProfile.ContainsKey("birthday") ? userProfile["birthday"] : "";
		relationshipLabelMesh.text = userProfile.ContainsKey("relationship") ? userProfile["relationship"] : "";
		StartCoroutine("UpdateProfilePictureTexture", userProfile["pictureURL"]);
	}

	private IEnumerator UpdateProfilePictureTexture(string pictureURL)
	{
		string url = pictureURL + "&access_token=" + FB.AccessToken;;
		WWW www = new WWW(url);
		yield return www;
		profilePictureRenderer.materials[0].mainTexture = www.texture;
	}

	private void showLoggedIn() {
		foreach (Transform child in loggedOutUIElements.transform)
		{
			child.renderer.enabled = false;
		}
		foreach (Transform child in loggedInUIElements.transform)
		{
			child.renderer.enabled = true;
		}
	}

	private void showLoggedOut() {
		foreach (Transform child in loggedInUIElements.transform)
		{
			child.renderer.enabled = false;
		}
		foreach (Transform child in loggedOutUIElements.transform)
		{
			child.renderer.enabled = true;
		}
		profilePictureRenderer.materials[0].mainTexture = defaultProfilePictureTexture;
	}

	// Wrap text by line height
	private string ResolveTextSize(string input, int lineLength){
		
		// Split string by char " "    
		string[] words = input.Split(" "[0]);
		
		// Prepare result
		string result = "";
		
		// Temp line string
		string line = "";
		
		// for each all words     
		foreach(string s in words){
			// Append current word into line
			string temp = line + " " + s;
			
			// If line length is bigger than lineLength
			if(temp.Length > lineLength){
				
				// Append current line into result
				result += line + "\n";
				// Remain word append into new line
				line = s;
			}
			// Append current word into current line
			else {
				line = temp;
			}
		}
		
		// Append last line into result   
		result += line;
		
		// Remove first " " char
		return result.Substring(1,result.Length-1);
	}
	
}
