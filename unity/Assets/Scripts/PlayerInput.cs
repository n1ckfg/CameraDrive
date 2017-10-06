using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerInput : MonoBehaviour {

    public GameManager gm;
    public BasicController ctl;
	
	void Update () {
        if (Input.GetKeyDown(KeyCode.Space)) gm.reset();

        if (ctl.clicked && ctl.isLooking && ctl.isLookingAt.StartsWith("Base")) {
            GameObject.Find(ctl.isLookingAt).GetComponent<Base>().doIsVisited();
        }
	}
}
